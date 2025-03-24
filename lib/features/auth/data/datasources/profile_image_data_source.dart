// lib/features/auth/data/datasources/profile_image_data_source.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:secondproject/core/errors/exceptions.dart';

// lib/features/auth/data/datasources/profile_image_data_source.dart
abstract class ProfileImageDataSource {
  Future<String> uploadImage(File image);
}

class CloudinaryImageDataSourceImpl implements ProfileImageDataSource {
  @override
  Future<String> uploadImage(File image) async {
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
        throw ServerException('Upload failed with status ${response.statusCode}');
      }
    } catch (e) {
      throw ServerException('Error uploading image: $e');
    }
  }
}
