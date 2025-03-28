// lib/features/auth/data/model/user_model.dart
import 'package:secondproject/features/auth/domain/entities/user_entity.dart';

class UserModel {
  
  final String email;
  final String password;
  final String username;
  final String phoneNumber;
  final String ?imageUrl;

  UserModel({
    required this.email,
    required this.password,
    required this.username,
    required this.phoneNumber,
     this.imageUrl,
  });

  // Convert UserModel to a Map for Firestore
  Map<String, dynamic> toJson() {
      print("📊 toJson called with imageUrl: $imageUrl");
    return {
      'email': email,
      'username': username,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl??"",
    };
  }

  // Create UserModel from Firestore Data
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'],
      username: json['username'],
      phoneNumber: json['phoneNumber'],
      imageUrl: json['imageUrl'],
      password: '', // Password not stored in Firestore
    );
  }

  // Convert UserEntity to UserModel
  factory UserModel.fromEntity(UserEntity entity, {required String password}) {
    return UserModel(
      email: entity.email,
      password: password,
      username: entity.username,
      phoneNumber: entity.phoneNumber,
      imageUrl: entity.imageUrl ?? '',
    );
  }
}
