// import 'dart:developer';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:secondproject/features/home_logout/data/models/category_model.dart';
// import 'package:secondproject/features/home_logout/data/models/service_model.dart';

// abstract class HomeRemoteDataSource {
//   Future<List<CategoryModel>> getCategories();
//   Future<List<ServiceModel>> getServices(String categoryId);
// }

// class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
//   final FirebaseFirestore firestore;

//   HomeRemoteDataSourceImpl(this.firestore);

//   @override
//   Future<List<CategoryModel>> getCategories() async {
//     try {
//       final querySnapshot = await firestore.collection('categories').get();
//       return querySnapshot.docs
//           .map((doc) => CategoryModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch categories: $e');
//     }
//   }

//   @override
//   Future<List<ServiceModel>> getServices(String categoryId) async {
//     try {
//       final querySnapshot = await firestore
//           .collection('categories')
//           .doc(categoryId)
//           .collection('services')
//           .get();
          
//       return querySnapshot.docs
//           .map((doc) => ServiceModel.fromFirestore(doc))
//           .toList();
//     } catch (e) {
//       throw Exception('Failed to fetch services: $e');
//     }
//   }



// }
