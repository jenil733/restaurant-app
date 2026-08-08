import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../controller/profile_controller.dart';
import 'widgets/profile_card.dart';
import 'widgets/restaurant_info_card.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/view/profile/add_profile_screen.dart' as add_profile;
import 'package:restaurant_app/src/presentation/widgets/app_embedded_image.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8F8F8),
      
      body: Stack(
        children: [
          // Header
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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [
                  _topBar(),

                  const SizedBox(height: 15),

                  profileCard(controller),

                  const SizedBox(height: 22),

                  GestureDetector(
                    onTap: () => Get.to(() => add_profile.ProfileScreen()),
                    child: restaurantCard(controller),
                  ),

                  const SizedBox(height: 18),

                  _businessCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBar() {
  return Row(
    children: [
      // Container(
      //   height: 44,
      //   width: 44,
      //   decoration: BoxDecoration(
      //     color: Colors.white,
      //     borderRadius: BorderRadius.circular(12),
      //   ),
      //   child: IconButton(
      //     onPressed: () => Get.back(),
      //     icon: const Icon(Icons.arrow_back_ios_new),
      //   ),
      // ),
      const SizedBox(width: 18),
      const Text(
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
      icon: SvgPicture.asset(
        businessInfo,
        width: 22,
        height: 22,
      ),
      children: [
        infoRow(
          SvgPicture.asset(
            restaurantId,
            width: 35,
            height: 35,
          ),
          "Restaurant ID",
          controller.restaurantId.value,
          iconColor: Colors.purple,
          // bgColor: Colors.purple.withOpacity(0.1),
        ),
        infoRow(
          const Icon(Icons.access_time, size: 20),
          "Store Timing",
          controller.storeTiming.value,
          iconColor: Colors.blue,
          bgColor: Colors.blue.withOpacity(0.1),
        ),
      ],
    ),
  );
}
}