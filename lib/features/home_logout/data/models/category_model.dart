import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required String id,
    required String name,
 required DateTime createdAt,
  }) : super(
          id: id,
          name: name,
        createdAt: createdAt,
        );

  factory CategoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CategoryModel(
      id: doc.id,
      name: data['name'] ?? '',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }
}