import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/onboarding_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/app_button.dart';

class OnboardingScreen extends GetView<OnboardingController> {
  const OnboardingScreen({super.key});

  static const List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      image: onboardingOrderImage,
      title: 'Manage Every Order in One Place',
      description:
          'Receive, accept, and track customer\n'
          'orders in real time from one simple\n'
          'dashboard.',
    ),
    _OnboardingPageData(
      image: onboardingMenuImage,
      title: 'Update Your Menu Anytime',
      description:
          'Add new dishes, edit prices, manage\n'
          'categories, and control item\n'
          'availability instantly.',
    ),
    _OnboardingPageData(
      image: onboardingGrowthImage,
      title: 'Track & Grow Your Restaurant',
      description:
          'Monitor sales, manage customers, and\n'
          'gain valuable insights to grow your\n'
          'business.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _SkipButton(onTap: controller.skipToLastPage),
            Expanded(
              child: PageView.builder(
                controller: controller.pageController,
                onPageChanged: controller.onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _OnboardingPage(
                    data: _pages[index],
                    controller: controller,
                  );
                },
              ),
            ),
            _NavigationButtons(controller: controller),
          ],
        ),
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, right: 24),
        child: Material(
          color: AppColors.textprimary,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(14),
            child: const Padding(
              padding: EdgeInsets.fromLTRB(9, 5, 6, 5),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: 3),
                  Icon(
                    Icons.skip_next_rounded,
                    size: 15,
                    color: AppColors.white,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({required this.data, required this.controller});

  final _OnboardingPageData data;
  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final imageSize = (screenSize.width * 0.78).clamp(240.0, 332.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(flex: 1),
          SvgPicture.asset(
            data.image,
            width: imageSize,
            height: imageSize,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 16),
          _PageIndicator(controller: controller),
          SizedBox(height: screenSize.height < 700 ? 16 : 26),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: TextHelper.heading1,
          ),
          const SizedBox(height: 18),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: TextHelper.heading2,
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(OnboardingController.pageCount, (index) {
          final isActive = controller.currentPage.value == index;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 20,
            height: 4,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }),
      ),
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons({required this.controller});

  final OnboardingController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.fromLTRB(32, 8, 24, 22),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedOpacity(
              opacity: controller.currentPage.value == 0 ? 0 : 1,
              duration: const Duration(milliseconds: 200),
              child: IgnorePointer(
                ignoring: controller.currentPage.value == 0,
                child: TextButton(
                  onPressed: controller.previousPage,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    textStyle: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Back'),
                ),
              ),
            ),
            AppButton(text: 'Next', onPressed: controller.nextPage),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;
}
