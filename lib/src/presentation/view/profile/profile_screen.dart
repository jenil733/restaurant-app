import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';
import 'widgets/profile_card.dart';
import 'widgets/restaurant_info_card.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/view/profile/add_profile_screen.dart'
    as add_profile;
import 'package:restaurant_app/src/presentation/widgets/app_embedded_image.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.isRegistered<ProfileController>()
      ? Get.find<ProfileController>()
      : Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      body: Stack(
        children: [
          // Header background
          ClipRRect(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(28),
              bottomRight: Radius.circular(28),
            ),
            child: const SizedBox(
              height: 165,
              width: double.infinity,
              child: AppEmbeddedImage(
                asset: header,
                fit: BoxFit.cover,
                fallback: ColoredBox(color: AppColors.primary),
              ),
            ),
          ),

          SafeArea(
            child: RefreshIndicator(
              onRefresh: () => controller.fetchProfile(isRefresh: true),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _topBar(),
                    const SizedBox(height: 15),
                    profileCard(controller),
                    const SizedBox(height: 22),
                    GestureDetector(
                      onTap: () =>
                          Get.to(() => const add_profile.ProfileScreen()),
                      child: restaurantCard(controller),
                    ),
                    const SizedBox(height: 18),
                    _businessCard(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
    return const Row(
      children: [
        SizedBox(width: 18),
        Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _businessCard() {
    return Obx(
      () => infoCard(
        title: "Business Information",
        icon: SvgPicture.asset(businessInfo, width: 22, height: 22),
        children: [
          if (controller.licenseNo.value.isNotEmpty)
            infoRow(
              Icons.verified_outlined,
              "License No",
              controller.licenseNo.value,
              iconColor: Colors.teal,
              bgColor: Colors.teal.withOpacity(0.1),
            ),
          if (controller.gstin.value.isNotEmpty)
            infoRow(
              Icons.receipt_long_outlined,
              "GSTIN",
              controller.gstin.value,
              iconColor: Colors.indigo,
              bgColor: Colors.indigo.withOpacity(0.1),
            ),
          if (controller.restaurantId.value.isNotEmpty && controller.restaurantId.value != 'null')
            infoRow(
              SvgPicture.asset(restaurantId, width: 35, height: 35),
              "Restaurant ID",
              controller.restaurantId.value.startsWith('#')
                  ? controller.restaurantId.value
                  : '#${controller.restaurantId.value}',
              iconColor: Colors.purple,
            ),
          infoRow(
            const Icon(Icons.access_time, size: 20),
            "Store Timing",
            controller.storeTiming.value.isNotEmpty
                ? controller.storeTiming.value
                : "N/A",
            iconColor: Colors.blue,
            bgColor: Colors.blue.withOpacity(0.1),
          ),
        ],
      ),
    );
  }
}
