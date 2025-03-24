// lib/features/auth/domain/usercase/upload_image.dart
import 'dart:io';

import 'package:secondproject/features/auth/domain/repositories/profile_image_repository.dart';

class UploadImage {
  final ProfileImageRepository repository;

  UploadImage(this.repository);

  Future<String> call(File image) async {
    return await repository.uploadImage(image);
  }
}
