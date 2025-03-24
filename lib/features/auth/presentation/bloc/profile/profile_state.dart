

import 'dart:io';
abstract class ProfileImageState {}

class ProfileImageInitial extends ProfileImageState {}

class ProfileImagePicked extends ProfileImageState {
  final File image;
  ProfileImagePicked(this.image);
}

class ProfileImageUploading extends ProfileImageState {}

class ProfileImageUploaded extends ProfileImageState {
  final String imageUrl;
  ProfileImageUploaded(this.imageUrl);
}

class ProfileImageError extends ProfileImageState {
  final String message;
  ProfileImageError(this.message);
}
