// offerbanner_state.dart
import 'package:equatable/equatable.dart';

abstract class OfferBannerState extends Equatable {
  const OfferBannerState();
  @override
  List<Object?> get props => [];
}

class BannerInitial extends OfferBannerState {}

class BannerLoading extends OfferBannerState {}

class BannerLoaded extends OfferBannerState {
  final List<String> bannerImages;
  final int currentIndex;
  
  const BannerLoaded(this.bannerImages, this.currentIndex);
  
  @override
  List<Object?> get props => [bannerImages, currentIndex];
   BannerLoaded copyWith({
    List<String>? bannerImages,
    int? currentIndex,
  }) {
    return BannerLoaded(
      bannerImages ?? this.bannerImages,
      currentIndex ?? this.currentIndex,
    );
  }
}



class BannerError extends OfferBannerState {
  final String message;
  
  const BannerError([this.message = 'An error occurred']);
  
  @override
  List<Object?> get props => [message];
}