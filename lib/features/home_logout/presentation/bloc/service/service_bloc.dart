import 'dart:developer';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';

// services_bloc.dart
class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _repository;

  ServicesBloc(this._repository) : super(ServicesInitial()) {
    on<LoadCategoriesAndServices>(_onLoadCategoriesAndServices); // Fix: Remove the "!" 
    on<LoadCategories>(_onLoadCategories);  // Separate handler for LoadCategories
    on<LoadServicesByCategory>(_onLoadServicesByCategory);
    on<LoadAllServices>(_onLoadAllServices);
    on<SearchQuery>(_onSearchQuery);
  }

  // Handle LoadCategoriesAndServices event
  Future<void> _onLoadCategoriesAndServices(
    LoadCategoriesAndServices event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final categories = await _repository.getCategories();
      final services = await _repository.getAllServices();

      if (categories.isEmpty && services.isEmpty) {
        emit(ServicesError(
          'No data available',
          technicalDetails: 'Both categories and services queries returned empty lists',
        ));
        return;
      }

      emit(ServicesAndCategoriesLoaded(
        categories: categories,
        services: services,
      ));
    } catch (e, stackTrace) {
      log('Error loading categories and services', error: e, stackTrace: stackTrace);
      emit(ServicesError(
        'Failed to load data. Please check your connection and try again.',
        technicalDetails: e.toString(),
      ));
    }
  }

  // Handle LoadCategories event separately
  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final categories = await _repository.getCategories();

      if (categories.isEmpty) {
        emit(ServicesError(
          'No categories available',
          technicalDetails: 'Categories query returned an empty list',
        ));
        return;
      }

      emit(ServicesCategoriesLoaded(
        categories: categories,
      ));
    } catch (e, stackTrace) {
      log('Error loading categories', error: e, stackTrace: stackTrace);
      emit(ServicesError(
        'Failed to load categories',
        technicalDetails: e.toString(),
      ));
    }
  }

  // Handle LoadServicesByCategory event
  Future<void> _onLoadServicesByCategory(
    LoadServicesByCategory event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final services = await _repository.getServicesByCategory(event.categoryId);
      final categories = await _repository.getCategories(); // Get categories too

      emit(ServicesAndCategoriesLoaded(
        categories: categories,
        services: services,
      ));
    } catch (e, stackTrace) {
      log('Error loading services by category', error: e, stackTrace: stackTrace);
      emit(ServicesError(
        'Failed to load services for this category',
        technicalDetails: e.toString(),
      ));
    }
  }

  // Handle LoadAllServices event
  Future<void> _onLoadAllServices(
    LoadAllServices event,
    Emitter<ServicesState> emit,
  ) async {
    final currentState = state;
    if (currentState is ServicesAndCategoriesLoaded) {
      try {
        final services = await _repository.getAllServices();
        emit(currentState.copyWith(services: services));
      } catch (e, stackTrace) {
        log('Error loading all services', error: e, stackTrace: stackTrace);
        emit(ServicesError(
          'Failed to load services',
          technicalDetails: e.toString(),
        ));
      }
    }
  }

  // Handle SearchQuery event
  Future<void> _onSearchQuery(
    SearchQuery event,
    Emitter<ServicesState> emit,
  ) async {
    final currentState = state;
    if (currentState is ServicesAndCategoriesLoaded) {
      final query = event.query.toLowerCase();
      
      if (query.isEmpty) {
        emit(currentState.copyWith(
          filteredCategories: [],
          filteredServices: [],
          searchQuery: query,
        ));
      } else {
        final filteredCategories = currentState.categories
            .where((category) => category.name.toLowerCase().contains(query))
            .toList();

        final filteredServices = currentState.services
            .where((service) =>
                service.name.toLowerCase().contains(query) ||
                service.description.toLowerCase().contains(query))
            .toList();

        emit(currentState.copyWith(
          filteredCategories: filteredCategories,
          filteredServices: filteredServices,
          searchQuery: query,
        ));
      }
    }
  }
}
