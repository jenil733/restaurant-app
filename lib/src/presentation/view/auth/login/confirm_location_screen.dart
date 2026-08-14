import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';
import 'package:restaurant_app/src/presentation/controller/auth/confirm_location_controller.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';


class ConfirmLocationScreen extends StatelessWidget {
  ConfirmLocationScreen({super.key});

  final LocationConfirmController controller =
      Get.put(LocationConfirmController());

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
              // =================================
              // LOCATION IMAGE
              // =================================

              SizedBox(
                height: size.height * 0.41,
                width: double.infinity,
                child: Transform.translate(
  offset: const Offset(0, 70),
  child: Image.asset(
                  confirmLocation,
                  fit: BoxFit.contain,
                ),
),
                
              ),
              const SizedBox(height: 50),
              // =================================
              // TITLE
              // =================================
              
              Text(
                'Current Location Found',
                textAlign: TextAlign.center,
                style: TextHelper.locationheading,
              ),

              const SizedBox(height: 26),

              // =================================
              // DESCRIPTION
              // =================================

              Text(
                "We’ve detected your current\n"
                "location please confirm if it’s\n"
                "correct",
                textAlign: TextAlign.center,
                style: TextHelper.button.copyWith(
                  color: AppColors.locationSubtext,
                  height: 1.45,
                ),
              ),

              const SizedBox(height: 28),

              // =================================
              // ADDRESS CARD
              // =================================

              Obx(
                () => Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9F5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xFFFFE1D2),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Location icon
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Color(0xFFFF4545),
                          size: 28,
                        ),
                      ),

                      const SizedBox(width: 20),

                      // Address
                      Expanded(
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                child: LinearProgressIndicator(
                                  minHeight: 2,
                                ),
                              )
                            : Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    controller.address.value.isEmpty
                                        ? 'Current location'
                                        : controller.address.value,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextHelper.button.copyWith(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF252B35),
                                    ),
                                  ),

                                  const SizedBox(height: 4),

                                  Text(
                                    '${controller.city.value}, '
                                    '${controller.state.value}'
                                    '${controller.pincode.value.isNotEmpty ? '-${controller.pincode.value}' : ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextHelper.button.copyWith(
                                      fontSize: 12,
                                      color: const Color(0xFF252B35),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(),

              // =================================
              // CONFIRM LOCATION
              // =================================

              Obx(
                () => CustomButton(
                  text: 'Confirm Location',
                  height: 44,
                  borderRadius: 6,
                  backgroundColor: const Color(0xFFFF823E),
                  textColor: Colors.white,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.confirmLocation,
                ),
              ),

              const SizedBox(height: 20),

              // =================================
              // CHOOSE ANOTHER LOCATION
              // =================================

              SizedBox(
                width: double.infinity,
                height: 44,
                child: OutlinedButton(
                  onPressed: controller.chooseAnotherLocation,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: Color(0xFFFFB58F),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    'Choose Another location',
                    style: TextHelper.button.copyWith(
                      color: AppColors.locationSubtext,
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