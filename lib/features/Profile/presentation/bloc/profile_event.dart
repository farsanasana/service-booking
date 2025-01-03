abstract class ProfileEvent {}

class LoadProfile extends ProfileEvent {
  final String userId;

  LoadProfile(this.userId);
}
