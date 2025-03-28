class UserEntity {
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final String? imageUrl;
  final DateTime ?createdAt;
 final String ?id;
  UserEntity({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
    this.imageUrl,
        this.createdAt,     this.id,
  });
}