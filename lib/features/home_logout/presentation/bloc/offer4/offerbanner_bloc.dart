// offerbanner_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:developer' as developer;

import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_state.dart';

class OfferBannerBloc extends Bloc<OfferBannerEvent, OfferBannerState> {
  final FirebaseFirestore _firestore;

  OfferBannerBloc({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        super(BannerInitial()) {
    on<LoadBannerImages>(_onLoadBannerImages);
    on<ChangeOfferBanner>(_onChangeBanner);
  }

  Future<void> _onLoadBannerImages(
    LoadBannerImages event,
    Emitter<OfferBannerState> emit
  ) async {
    emit(BannerLoading());
    try {
      developer.log('Fetching offers from Firestore');
      
      // Use a specific path and limit the query
      final QuerySnapshot snapshot = await _firestore
          .collection('offers')  // Changed from 'offers' to 'banners'
          .limit(5)
          .get();

      developer.log('Retrieved ${snapshot.docs.length} documents');

      List<String> images = [];
      
      for (var doc in snapshot.docs) {
        try {
          developer.log('Processing document: ${doc.id}');
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          developer.log('Document data: $data');

          // Try multiple possible field names
          String? imageUrl = data['imageUrl'] as String? ?? 
                           data['image_url'] as String? ??
                           data['url'] as String? ??
                           data['image'] as String?;

          if (imageUrl != null && imageUrl.isNotEmpty) {
            developer.log('Found valid image URL: $imageUrl');
            images.add(imageUrl);
          } else {
            developer.log('No valid image URL found in document ${doc.id}');
          }
        } catch (e) {
          developer.log('Error processing document ${doc.id}: $e');
          continue;  // Skip problematic documents
        }
      }

      if (images.isEmpty) {
        developer.log('No images found, using default images');
        // Provide default images as fallback
        images = [
          'https://via.placeholder.com/800x400?text=Service+1',
          'https://via.placeholder.com/800x400?text=Service+2',
          'https://via.placeholder.com/800x400?text=Service+3',
        ];
      }

      developer.log('Emitting BannerLoaded with ${images.length} images');
      emit(BannerLoaded(images, 0));
      
    } catch (e, stackTrace) {
      developer.log(
        'Error loading banner images',
        error: e,
        stackTrace: stackTrace
      );
      emit(BannerError('Failed to load offers: ${e.toString()}'));
    }
  }

  void _onChangeBanner(
    ChangeOfferBanner event,
    Emitter<OfferBannerState> emit
  ) {
    if (state is BannerLoaded) {
      final currentState = state as BannerLoaded;
      emit(currentState.copyWith(currentIndex: event.newIndex));
    }
  }
}