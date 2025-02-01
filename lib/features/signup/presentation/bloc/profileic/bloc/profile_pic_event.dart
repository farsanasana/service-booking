// profile_pic_event.dart
import 'dart:io';

abstract class ImageEvent {}

class PickImageEvent extends ImageEvent {}

class UploadImageEvent extends ImageEvent {
  final File image;
  UploadImageEvent(this.image);
}

