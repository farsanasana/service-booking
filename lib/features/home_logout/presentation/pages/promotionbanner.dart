import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_bloc.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_event.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/banner/banner_state.dart';
import 'package:secondproject/features/home_logout/presentation/bloc/offer4/offerbanner_bloc.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class PromotionBanner extends StatelessWidget {
  final List<String> bannerImages = [
    'assets/images/cleaning_banner.jpg',
    'assets/images/cleaning_banner2.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BannerBloc(),
      child: _PromotionBannerContent(bannerImages: bannerImages),
    );
  }
}

class _PromotionBannerContent extends StatelessWidget {
  final List<String> bannerImages;

  const _PromotionBannerContent({Key? key, required this.bannerImages}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            return CarouselSlider(
              options: CarouselOptions(
                height: 180,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                enlargeCenterPage: true,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  context.read<BannerBloc>().add(ChangeBanner(index));
                },
              ),
              items: bannerImages.map((imagePath) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 8),
        BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            return AnimatedSmoothIndicator(
              activeIndex: state.currentIndex,
              count: bannerImages.length,
              effect: ExpandingDotsEffect(
                dotHeight: 10,
                dotWidth: 10,
                activeDotColor: Colors.orange,
                dotColor: Colors.grey,
              ),
            );
          },
        ),
      ],
    );
  }
}
