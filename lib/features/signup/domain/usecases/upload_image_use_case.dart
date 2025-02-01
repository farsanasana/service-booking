// // lib/domain/usecases/upload_image_use_case.dart

// import 'package:dartz/dartz.dart';
// import 'package:image_picker/image_picker.dart';

// import 'package:secondproject/features/signup/data/repositories/image_repository.dart';

// class UploadImageUseCase {
//   final ImageRepository imageRepository;

//   UploadImageUseCase(this.imageRepository);

//   Future<Either<String, String>> execute(XFile imageFile) async {
//     return await imageRepository.uploadImage(imageFile);
//   }
// }
