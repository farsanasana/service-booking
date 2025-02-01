import 'dart:io';

abstract class ImageState {}

class ImageInitialState extends ImageState {}

class ImagePickedState extends ImageState {
  final File image;
  ImagePickedState(this.image);
}

class ImageUploadingState extends ImageState {}

class ImageUploadedState extends ImageState {
  final String imageUrl;
  ImageUploadedState(this.imageUrl);
}

class ImageErrorState extends ImageState {
  final String message;
  ImageErrorState(this.message);
}
