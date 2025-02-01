import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';

abstract class ServicesRepository {
  Future<List<Category>> getCategories();
  Future<List<Service>> getServicesByCategory(String categoryId);
}