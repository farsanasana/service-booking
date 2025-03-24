// lib/features/auth/domain/repositories/profile_image_repository.dart
import 'dart:io';

abstract class ProfileImageRepository {
  Future<String> uploadImage(File image);
}
