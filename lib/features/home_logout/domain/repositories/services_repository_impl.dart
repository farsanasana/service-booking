
// service_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';

class ServicesRepositoryImpl implements ServicesRepository {
  final FirebaseFirestore _firestore;

  ServicesRepositoryImpl(this._firestore);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('categories').get();
      
      return snapshot.docs.map((doc) => Category(
        id: doc.id,
        name: doc['name'] as String,
    createdAt: (doc['createdAt'] as Timestamp).toDate(),
      )).toList();
    } catch (e) {
      throw Exception('Failed to fetch categories: ${e.toString()}');
    }
  }

  @override
  Future<List<Service>> getServicesByCategory(String categoryId) async {
    try {
      final snapshot = await _firestore
          .collection('services')
          .where('categoryId', isEqualTo: categoryId)
          .get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Service(
          id: doc.id,
          name: data['name'] as String,
          imageUrl: data['imageUrl'] as String,
          categoryId: data['categoryId'] as String,
          description: data['description'] as String,
          createdAt: (data['createdAt'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      throw Exception('Failed to fetch services: ${e.toString()}');
    }
  }
}