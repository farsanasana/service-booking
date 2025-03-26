
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';

abstract class ServicesState {}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {}

class ServicesAndCategoriesLoaded extends ServicesState {
  final List<Category> categories;
  final List<Service> services;
  final List<Category> filteredCategories;
  final List<Service> filteredServices;
  final String searchQuery;

  ServicesAndCategoriesLoaded({
    required this.categories,
    required this.services,
    this.filteredCategories = const [],
    this.filteredServices = const [],
    this.searchQuery = '',
  });

  ServicesAndCategoriesLoaded copyWith({
    List<Category>? categories,
    List<Service>? services,
    List<Category>? filteredCategories,
    List<Service>? filteredServices,
    String? searchQuery,
  }) {
    return ServicesAndCategoriesLoaded(
      categories: categories ?? this.categories,
      services: services ?? this.services,
      filteredCategories: filteredCategories ?? this.filteredCategories,
      filteredServices: filteredServices ?? this.filteredServices,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class ServicesCategoriesLoaded extends ServicesState {
  final List<Category> categories;

  ServicesCategoriesLoaded({
    required this.categories,
  });
}
class ServiceSearchState extends ServicesState {
  final List<Service> filteredServices;
  final String searchQuery;
  
  ServiceSearchState(this.filteredServices, this.searchQuery);
}

class ServicesError extends ServicesState {
  final String message;
  final String? technicalDetails;

  ServicesError(this.message, {this.technicalDetails});
}
