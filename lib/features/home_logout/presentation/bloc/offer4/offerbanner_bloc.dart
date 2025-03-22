// offerbanner_bloc.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      
      // Use a specific path and limit the query
      final QuerySnapshot snapshot = await _firestore
          .collection('offers')  // Changed from 'offers' to 'banners'
          .limit(5)
          .get();


      List<String> images = [];
      
      for (var doc in snapshot.docs) {
        try {
          final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

          // Try multiple possible field names
          String? imageUrl = data['imageUrl'] as String? ?? 
                           data['image_url'] as String? ??
                           data['url'] as String? ??
                           data['image'] as String?;

          if (imageUrl != null && imageUrl.isNotEmpty) {
            images.add(imageUrl);
          } else {
          }
        } catch (e) {
          continue;  // Skip problematic documents
        }
      }

      if (images.isEmpty) {
        // Provide default images as fallback
        images = [
          'https://via.placeholder.com/800x400?text=Service+1',
          'https://via.placeholder.com/800x400?text=Service+2',
          'https://via.placeholder.com/800x400?text=Service+3',
        ];
      }

      emit(BannerLoaded(images, 0));
      
    } catch (e) {

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