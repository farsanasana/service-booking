class BannerState {
  final int currentIndex;
  BannerState(this.currentIndex);
  
  // Optional: add equality methods
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BannerState &&
          runtimeType == other.runtimeType &&
          currentIndex == other.currentIndex;

  @override
  int get hashCode => currentIndex.hashCode;
}