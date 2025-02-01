// // // lib/data/repositories/image_repository.dart

// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import 'package:dartz/dartz.dart';

// class ImageRepository {
//   final FirebaseStorage firebaseStorage;

//   ImageRepository(this.firebaseStorage);

//   Future<Either<String, String>> uploadImage(XFile imageFile) async {
//     try {
//       // Create a reference to Firebase Storage
//       final ref = firebaseStorage.ref().child('profile_pictures/${DateTime.now().toString()}');

//       // Upload the image to Firebase Storage
//       final uploadTask = ref.putFile(File(imageFile.path));

//       // Wait for the upload to complete and get the URL
//       final snapshot = await uploadTask.whenComplete(() {});
//       final downloadUrl = await snapshot.ref.getDownloadURL();

//       return Right(downloadUrl); // Return the image URL if successful
//     } catch (e) {
//       return Left('Failed to upload image: $e'); // Return error message if something goes wrong
//     }
//   }
// }
