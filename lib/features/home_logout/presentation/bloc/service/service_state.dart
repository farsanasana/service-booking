


import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class CategoriesLoaded extends ServicesState {
  final List<Category> categories;

  CategoriesLoaded(this.categories);
}

class ServicesLoaded extends ServicesState {
  final List<Service> services;

  ServicesLoaded(this.services);
}

class ServicesError extends ServicesState {
  final String message;

  ServicesError(this.message);
}
