// lib/features/auth/data/repositories/profile_image_repository_impl.dart
import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:secondproject/core/errors/exceptions.dart';
import 'package:secondproject/core/errors/failures.dart';
import 'package:secondproject/features/auth/domain/repositories/profile_image_repository.dart';
import '../datasources/profile_image_data_source.dart';

// lib/features/auth/data/repositories/profile_image_repository_impl.dart
class ProfileImageRepositoryImpl implements ProfileImageRepository {
  final ProfileImageDataSource dataSource;

  ProfileImageRepositoryImpl({required this.dataSource});

  @override
  Future<String> uploadImage(File image) async {
    return await dataSource.uploadImage(image);
  }
}
