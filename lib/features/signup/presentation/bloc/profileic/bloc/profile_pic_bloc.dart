import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_event.dart';
import 'package:secondproject/features/signup/presentation/bloc/profileic/bloc/profile_pic_state.dart';

class ImageBloc extends Bloc<ImageEvent, ImageState> {
  final ImagePicker _picker = ImagePicker();
  ImageBloc() : super(ImageInitialState()){
     on<PickImageEvent>(_handlePickImage);
    on<UploadImageEvent>(_handleUploadImage);
  }




    Future<void> _handlePickImage(
    PickImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        emit(ImagePickedState(File(pickedFile.path)));
      } else {
        emit(ImageErrorState('No image selected'));
      }
    } catch (e) {
      emit(ImageErrorState('Error picking image: $e'));
    }
  }
   Future<void> _handleUploadImage(
    UploadImageEvent event,
    Emitter<ImageState> emit,
  ) async {
    try {
      emit(ImageUploadingState());
      final imageUrl = await _uploadToCloudinary(event.image);
      if (imageUrl != null) {
        emit(ImageUploadedState(imageUrl));
      } else {
        emit(ImageErrorState('Failed to get upload URL'));
      }
    } catch (e) {
      emit(ImageErrorState('Error uploading image: $e'));
    }
  }

    Future<String?> _uploadToCloudinary(File image) async {
    try {
      final url = Uri.parse('https://api.cloudinary.com/v1_1/dwhmt3yt2/upload');
      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = 'profileImg';
      request.files.add(await http.MultipartFile.fromPath('file', image.path));

      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = jsonDecode(responseString);
        return jsonMap['secure_url'] as String;
      } else {
        throw HttpException('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

}