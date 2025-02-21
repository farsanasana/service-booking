abstract class BannerEvent {}

class ChangeBanner extends BannerEvent {
  final int newIndex;
  ChangeBanner(this.newIndex);
}