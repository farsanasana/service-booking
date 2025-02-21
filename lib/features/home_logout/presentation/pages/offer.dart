import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_state.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OfferBanner extends StatelessWidget {
  const OfferBanner({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OfferBannerBloc, OfferBannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return const SizedBox(
            height: 180,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state is BannerLoaded) {
          return Column(
            children: [
              CarouselSlider(
                options: CarouselOptions(
                  height: 180,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 3),
                  enlargeCenterPage: true,
                  enableInfiniteScroll: true,
                  onPageChanged: (index, reason) {
                    context.read<OfferBannerBloc>().add(ChangeOfferBanner(index));
                  },
                ),
                items: state.bannerImages.map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey[200],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: Icon(
                                    Icons.image_not_supported,
                                    color: Colors.grey,
                                    size: 40,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              if (state.bannerImages.length > 1) ...[
                const SizedBox(height: 12),
                AnimatedSmoothIndicator(
                  activeIndex: state.currentIndex,
                  count: state.bannerImages.length,
                  effect: const ExpandingDotsEffect(
                    dotHeight: 8,
                    dotWidth: 8,
                    activeDotColor: Colors.orange,
                    dotColor: Colors.grey,
                  ),
                ),
              ],
            ],
          );
        } else if (state is BannerError) {
          return SizedBox(
            height: 180,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(height: 8),
                  Text(state.message),
                  TextButton(
                    onPressed: () {
                      context.read<OfferBannerBloc>().add(const LoadBannerImages());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}