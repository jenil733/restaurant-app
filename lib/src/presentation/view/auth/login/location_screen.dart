import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/auth/location_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';




class LocationScreen extends StatelessWidget {
  LocationScreen({super.key});

  final LocationController controller =
      Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFCFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      children: [
              // =========================
              // IMAGE
              // =========================

              SizedBox(
                height: size.height * 0.41,
                width: double.infinity,
                child: Transform.translate(
  offset: const Offset(0, 70),
  child: Image.asset(
    locationIcon,
    fit: BoxFit.contain,
  ),
),
              ),

              // =========================
              // TITLE
              // =========================
const SizedBox(height: 56),
              Text(
                "Let’s find food near you",
                textAlign: TextAlign.center,
                style: TextHelper.locationheading
              ),

              const SizedBox(height: 16),

              // =========================
              // DESCRIPTION
              // =========================

              Text(
                "Allow location access to discover\n"
                "restaurants and fast delivery near\n"
                "your location",
                textAlign: TextAlign.center,
                style: TextHelper.button.copyWith(
                  color:AppColors.locationSubtext,
                  fontSize: 15
                ),
              ),

              const Spacer(),

              // =========================
              // ALLOW BUTTON
              // =========================

              Obx(
                () => CustomButton(
                  text: "Allow Location access",
                  height: 44,
                  borderRadius: 6,
                  backgroundColor: const Color(0xFFFF823E),
                  textColor: Colors.white,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.allowLocation,
                ),
              ),

              const SizedBox(height: 20),

              // =========================
              // NOT NOW
              // =========================

              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: controller.notNow,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFFFB58F),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Not Now",
                    style: TextHelper.button.copyWith(
                  color:AppColors.locationSubtext
                ),
                  ),
                ),
              ),

              const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}