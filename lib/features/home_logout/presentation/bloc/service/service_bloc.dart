import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';

class ServicesBloc extends Bloc<ServicesEvent, ServicesState> {
  final ServicesRepository _repository;

  ServicesBloc(this._repository) : super(ServicesInitial()) {
    on<LoadCategories>(_onLoadCategories);
    on<LoadServicesByCategory>(_onLoadServicesByCategory);
  }

  Future<void> _onLoadCategories(
    LoadCategories event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final categories = await _repository.getCategories();
         log('category bloc');
      emit(CategoriesLoaded(categories));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }

  Future<void> _onLoadServicesByCategory(
    LoadServicesByCategory event,
    Emitter<ServicesState> emit,
  ) async {
    emit(ServicesLoading());
    try {
      final services = await _repository.getServicesByCategory(event.categoryId);
             log('category bloc');
      emit(ServicesLoaded(services));
    } catch (e) {
      emit(ServicesError(e.toString()));
    }
  }
}