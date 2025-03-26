

  import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';
import 'package:secondproject/features/home_logout/presentation/pages/offer.dart';
import 'package:secondproject/features/home_logout/presentation/pages/promotionbanner.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/buildCategoriesGrid.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/buildSectionTit.dart';
import 'package:secondproject/features/home_logout/presentation/pages/widget/buildServicesList.dart';

Widget buildHomeContent(BuildContext context) {
    return BlocBuilder<ServicesBloc, ServicesState>(
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

        if (state is ServicesAndCategoriesLoaded) {
          final displayCategories = state.searchQuery.isEmpty 
              ? state.categories 
              : state.filteredCategories;
          
          final displayServices = state.searchQuery.isEmpty 
              ? state.services 
              : state.filteredServices;

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ServicesBloc>().add(LoadCategories());
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PromotionBanner(),
                  buildSectionTitle('Categories'),
                  buildCategoriesGrid(displayCategories, context),
                  buildSectionTitle('Services'),
                  if (displayServices.isNotEmpty)
                    buildServicesList(displayServices, context)
                  else
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No services available'),
                      ),
                    ),
                  SizedBox(height: 20),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Special Offers', style: Theme.of(context).textTheme.titleLarge,),
                ),
                   OfferBanner(),
                ],
              ),
            ),
          );
        }

        return Center(child: Text('Something went wrong'));
      },
    );
  }
