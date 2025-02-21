// banner_event.dart
import 'package:equatable/equatable.dart';

abstract class OfferBannerEvent extends Equatable {
  const OfferBannerEvent();
  
  @override
  List<Object?> get props => [];
}

class LoadBannerImages extends OfferBannerEvent {
  const LoadBannerImages();
}
class ChangeOfferBanner extends OfferBannerEvent {
  final int newIndex;

  const ChangeOfferBanner(this.newIndex);

  @override
  List<Object?> get props => [newIndex];
}