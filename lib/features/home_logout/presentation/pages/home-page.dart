import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ServicesBloc(context.read<ServicesRepository>())
        ..add(LoadCategories()),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return Center(child: CircularProgressIndicator());
            }
            
            if (state is ServicesError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(state.message),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ServicesBloc>().add(LoadCategories());
                      },
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );
            }
            
            if (state is CategoriesLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ServicesBloc>().add(LoadCategories());
                },
                child: ListView(
                  children: [
                    _buildPromotionBanner(),
                    _buildCategoriesGrid(state.categories, context),
                  ],
                ),
              );
            }
            
            return SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      height: 150,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          'Cleaning Service SALE\nUp to 50% OFF',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories, BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ServiceListPage(category: category),
              ),
            );
          },
          child: Column(
            children: [
           
              SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        );
      },
    );
  }
}