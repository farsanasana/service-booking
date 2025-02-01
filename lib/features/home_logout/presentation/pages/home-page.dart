import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/repositories/service_repository.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';
import 'package:secondproject/features/home_logout/presentation/pages/service_list.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/service.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => ServicesBloc((context.read<ServicesRepository>()))
  ..add(LoadCategories()),
        child: Scaffold(
        body: BlocBuilder<ServicesBloc, ServicesState>(
          builder: (context, state) {
            if (state is ServicesLoading) {
              return Center(child: CircularProgressIndicator(),);
            }
             if (state is ServicesError) {
              return Center(child: Text(state.message));
            }
           if (state is CategoriesLoaded) {
              return ListView(
                children: [
                  // Sale Banner
                  Container(
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
                  ),
                  // Categories
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Services',
                      style: Theme.of(context).textTheme.titleLarge??Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: state.categories.length,
                    itemBuilder: (context, index) {
                      final category = state.categories[index];
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
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  category.imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
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
                  ),
                ],
              );
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

  // Widget _buildAppBar() {
  //   return SliverAppBar(
  //     floating: true,
  //     title: Row(
  //       children: [
  //         Container(
  //           width: 40,
  //           height: 40,
  //           decoration: BoxDecoration(
  //             color: Colors.orange,
  //             borderRadius: BorderRadius.circular(8),
  //           ),
  //           child: Center(
  //             child: Text(
  //               'A',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 24,
  //                 fontWeight: FontWeight.bold,
  //               ),
  //             ),
  //           ),
  //         ),
  //         SizedBox(width: 12),
  //         Text('A-SWAN SERVICES'),
  //       ],
  //     ),
  //     actions: [
  //       IconButton(
  //         icon: Icon(Icons.search),
  //         onPressed: () {
  //           // TODO: Implement search functionality
  //         },
  //       ),
  //       Stack(
  //         children: [
  //           IconButton(
  //             icon: Icon(Icons.notifications),
  //             onPressed: () {
  //               // TODO: Implement notifications
  //             },
  //           ),
  //           Positioned(
  //             right: 8,
  //             top: 8,
  //             child: Container(
  //               padding: EdgeInsets.all(2),
  //               decoration: BoxDecoration(
  //                 color: Colors.red,
  //                 borderRadius: BorderRadius.circular(6),
  //               ),
  //               constraints: BoxConstraints(
  //                 minWidth: 14,
  //                 minHeight: 14,
  //               ),
  //               child: Text(
  //                 '2',
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 8,
  //                 ),
  //                 textAlign: TextAlign.center,
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ],
  //   );
//   }
//   Widget _buildBody() {
//     return SliverToBoxAdapter(
//       child: BlocBuilder<HomeBloc, HomeState>(
//         builder: (context, state) {
//           if (state is HomeLoading) {
//             return const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(16),
//                 child: CircularProgressIndicator(),
//               ),
//             );
//           } else if (state is HomeError) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const Text(
//                       'Oops! Something went wrong',
//                       style: TextStyle(
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(state.message),
//                     const SizedBox(height: 16),
//                     ElevatedButton(
//                       onPressed: () {
//                         context.read<HomeBloc>().add(LoadHomeData());
//                       },
//                       child: const Text('Retry'),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           } else if (state is HomeCategoriesAndServicesLoaded) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 _buildPromotionBanner(),
//                 _buildSectionTitle('Services'),
//                 _buildCategoriesGrid(state.categories),
//                 _buildSectionTitle('Popular Services'),
//                 _buildPopularServicesGrid(state.services),
//                 _buildGeneralCleaning(),
//               ],
//             );
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   Widget _buildPromotionBanner() {
//     return Container(
//       margin: EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.green.shade300, Colors.green.shade500],
//         ),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Stack(
//         children: [
//           Padding(
//             padding: EdgeInsets.all(20),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Cleaning Service SALE',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Up to 50% off',
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 18,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             right: -20,
//             bottom: -20,
//             child: Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 shape: BoxShape.circle,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     return Padding(
//       padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 20,
//           fontWeight: FontWeight.bold,
//         ),
//       ),
//     );
//   }

//   Widget _buildCategoriesGrid(List<Category> categories) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: categories.length,
//       itemBuilder: (context, index) => CategoryCard(
//         category: categories[index],
//         onTap: () {
//           context.read<HomeBloc>().add(LoadServices(categories[index].id));
//         },
//       ),
//     );
//   }

//   Widget _buildPopularServicesGrid(List<Service> services) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: NeverScrollableScrollPhysics(),
//       padding: EdgeInsets.symmetric(horizontal: 16),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 3,
//         crossAxisSpacing: 16,
//         mainAxisSpacing: 16,
//         childAspectRatio: 0.85,
//       ),
//       itemCount: services.length,
//       itemBuilder: (context, index) => ServiceCard(
//         service: services[index],
//         onTap: () {
//           // TODO: Navigate to service details
//         },
//       ),
//     );
//   }

//   Widget _buildGeneralCleaning() {
//     return Padding(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'General Cleaning',
//             style: TextStyle(
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 16),
//           Container(
//             height: 120,
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               itemCount: 3,
//               itemBuilder: (context, index) {
//                 return Container(
//                   width: 120,
//                   margin: EdgeInsets.only(right: 16),
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     color: Colors.grey[200],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(12),
//                     child: Image.network(
//                       'https://via.placeholder.com/120',
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: 0,
//       selectedItemColor: Colors.orange,
//       unselectedItemColor: Colors.grey,
//       items: [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.calendar_today),
//           label: 'Schedule',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.payment),
//           label: 'Payment',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }