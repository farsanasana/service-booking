import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/Profile/presentation/pages/profile_screen.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/domain/entities/service.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';
import 'package:secondproject/features/home_logout/presentation/pages/servicesdetailspage.dart';
import 'package:secondproject/features/home_navigation/domain/entities/navigation_tab.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_bloc.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_event.dart';
import 'package:secondproject/features/home_navigation/presentation/bloc/navigation_state.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            final bloc = ServicesBloc(context.read<ServicesRepository>());
            bloc.add(LoadCategoriesAndServices());
            return bloc;
          },
        ),
        BlocProvider(
          create: (context) => NavigationBloc(),
        ),
      ],
      child: BlocBuilder<NavigationBloc, NavigationState>(
        builder: (context, state) {
          return Scaffold(
            appBar: _buildAppBar(context),
            body: _buildBody(context, state),
            bottomNavigationBar: BottomNavigationBar(
              selectedItemColor: Colors.orange,
              unselectedItemColor: Colors.grey,
              currentIndex: state.selectedTab.index,
              onTap: (index) {
                context.read<NavigationBloc>().add(
                  TabChanged(NavigationTab.values[index]),
                );
              },
              items: NavigationTab.values.map((tab) {
                return BottomNavigationBarItem(
                  icon: Icon(tab.icon),
                  label: tab.label,
                );
              }).toList(),
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: Row(
        children: [
          Image.asset("assets/images/abban_logo.png", height: 32),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                onChanged: (query) {
                  context.read<ServicesBloc>().add(SearchQuery(query: query));
                },
              ),
            ),
          ),
          SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      backgroundColor: Colors.white,
      elevation: 0,
    );
  }

  Widget _buildBody(BuildContext context, NavigationState navigationState) {
    switch (navigationState.selectedTab) {
      case NavigationTab.home:
        return _buildHomeContent(context);
      case NavigationTab.schedule:
        return Center(child: Text('Schedule Page'));
      case NavigationTab.payments:
        return Center(child: Text('Payments Page'));
      case NavigationTab.profile:
        return ProfilePage();
    }
  }

  Widget _buildHomeContent(BuildContext context) {
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
                  _buildPromotionBanner(),
                  _buildSectionTitle('Categories'),
                  _buildCategoriesGrid(displayCategories, context),
                  _buildSectionTitle('Services'),
                  if (displayServices.isNotEmpty)
                    _buildServicesList(displayServices, context)
                  else
                    Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text('No services available'),
                      ),
                    ),
                  SizedBox(height: 80),
                ],
              ),
            ),
          );
        }

        return Center(child: Text('Something went wrong'));
      },
    );
  }

  Widget _buildPromotionBanner() {
    return Container(
      height: 180,
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage('assets/images/cleaning_banner.jpg'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(List<Category> categories, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((category) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ServiceListPage(category: category),
                ),
              );
            },
            child: Container(
              width: 100,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    category.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServicesList(List<Service> services, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: services.map((service) {
          return GestureDetector(
            onTap: () {
              // Handle service selection
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ServiceDetailsPage(
      service: service,
    ),
  ),
);

            },
            child: Container(
              width: 120,
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (service.imageUrl.isNotEmpty)
                    ClipRRect(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                      child: Image.network(
                        service.imageUrl,
                        height: 80,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            color: Colors.grey[200],
                            child: Icon(Icons.image_not_supported, size: 40),
                          );
                        },
                      ),
                    ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      service.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}