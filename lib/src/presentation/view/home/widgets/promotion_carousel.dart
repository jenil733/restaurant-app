import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/presentation/widgets/app_embedded_image.dart';

class PromotionCarousel extends StatefulWidget {
  const PromotionCarousel({super.key});

  @override
  State<PromotionCarousel> createState() => _PromotionCarouselState();
}

class _PromotionCarouselState extends State<PromotionCarousel> {
  static const _bannerCount = 3;
  late final PageController _pageController;
  Timer? _loopTimer;
  var _currentBanner = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 999);
    _loopTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_pageController.hasClients) {
        return;
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubicEmphasized,
      );
    });
  }

  @override
  void dispose() {
    _loopTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(7),
        boxShadow: const [
          BoxShadow(
            color: Color(0x24000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 7),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (page) {
                    setState(() => _currentBanner = page % _bannerCount);
                  },
                  itemBuilder: (context, page) {
                    return const AppEmbeddedImage(
                      asset: homeBanner,
                      fit: BoxFit.cover,
                      fallback: ColoredBox(color: Color(0xFFFFC400)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var index = 0; index < _bannerCount; index++)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    width: index == _currentBanner ? 18 : 7,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 2),
                    decoration: BoxDecoration(
                      color: index == _currentBanner
                          ? AppColors.primary
                          : const Color(0xFFFFE4D2),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
