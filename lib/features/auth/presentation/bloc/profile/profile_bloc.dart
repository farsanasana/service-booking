import 'dart:io';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondproject/features/auth/domain/usercase/uplod_image.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_event.dart';
import 'package:secondproject/features/auth/presentation/bloc/profile/profile_state.dart';

class ProfileImageBloc extends Bloc<ProfileImageEvent, ProfileImageState> {
  final UploadImage uploadImageUseCase;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileImageBloc(this.uploadImageUseCase) : super(ProfileImageInitial()) {
    on<PickImageEvent>(_onPickImage);
    on<UploadImageEvent>(_onUploadImage);
  }

  Future<void> _onPickImage(
    PickImageEvent event,
    Emitter<ProfileImageState> emit,
  ) async {
    try {
      final pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );
      if (pickedFile != null) {
        emit(ProfileImagePicked(File(pickedFile.path)));
      }
    } catch (e) {
      emit(ProfileImageError('Failed to pick image: ${e.toString()}'));
    }
  }

  Future<void> _onUploadImage(
    UploadImageEvent event,
    Emitter<ProfileImageState> emit,
  ) async {
    emit(ProfileImageUploading());
    try {
      final imageUrl = await uploadImageUseCase(event.image);
     print("📸 Image uploaded successfully! URL: $imageUrl"); 
      emit(ProfileImageUploaded(imageUrl));
    } catch (e) {
       print("❌ Image upload error: $e");
      emit(ProfileImageError('Failed to upload image: ${e.toString()}'));
    }
  }
}