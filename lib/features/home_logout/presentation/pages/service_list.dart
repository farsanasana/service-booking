import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/domain/entities/category.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/service/service_state.dart';

class ServiceListPage extends StatelessWidget {
  final Category category;

  const ServiceListPage({
    Key? key,
    required this.category,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(category.name),
      ),
      body: BlocBuilder<ServicesBloc, ServicesState>(
        builder: (context, state) {
          // Load services when page is opened
          if (state is! ServicesLoaded) {
            context.read<ServicesBloc>().add(LoadServicesByCategory(category.id));
          }

          if (state is ServicesLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is ServicesError) {
            return Center(child: Text(state.message));
          }

          if (state is ServicesLoaded) {
            if (state.services.isEmpty) {
              return Center(
                child: Text('No services available in this category'),
              );
            }

            return ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: state.services.length,
              itemBuilder: (context, index) {
                final service = state.services[index];
                return Card(
                  margin: EdgeInsets.only(bottom: 16),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    onTap: () {
                      // TODO: Navigate to service detail page
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          service.imageUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      service.name,
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                  ),
                                  // Text(
                                  //   // '\$${service.price.toStringAsFixed(2)}',
                                  //   style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  //     color: Theme.of(context).primaryColor,
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: 8),
                              // Text(
                              //   service.description,
                              //   style: Theme.of(context).textTheme.bodyMedium,
                              //   maxLines: 2,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                              SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  // TODO: Implement booking functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 44),
                                ),
                                child: Text('Book Now'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return SizedBox();
        },
      ),
    );
  }
}