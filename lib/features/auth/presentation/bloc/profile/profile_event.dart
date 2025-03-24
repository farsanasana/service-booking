
import 'dart:io';
abstract class ProfileImageEvent {}

class PickImageEvent extends ProfileImageEvent {}

class UploadImageEvent extends ProfileImageEvent {
  final File image;
  UploadImageEvent(this.image);
}