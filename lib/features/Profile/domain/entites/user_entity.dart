class UserEntity {
  final String username;
  final String email;
final String phoneNumber;
final String imageUrl; 
  UserEntity({
    required this.username,
     required this.email,
     required this.phoneNumber,
     this.imageUrl=''});
}
