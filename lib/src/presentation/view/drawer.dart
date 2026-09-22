import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/api_routes.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/presentation/view/auth/widgets/logout_dialog.dart';
import 'package:restaurant_app/src/presentation/view/customer/customer_review_screen.dart';
import 'package:restaurant_app/src/presentation/view/feedback/feed_back_screen.dart';
import 'package:restaurant_app/src/presentation/view/help&Support/help_support_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/product_screen.dart';
import 'package:restaurant_app/src/presentation/view/products/category_screen.dart';
import 'package:restaurant_app/src/presentation/view/profile/profile_screen.dart' as profile_view;
import 'package:restaurant_app/src/presentation/view/profile/bank_detail_screen.dart';
import 'package:restaurant_app/src/presentation/view/sales/sales_screen.dart';
import 'package:restaurant_app/src/presentation/view/setting_screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final profileController = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    if (profileController.profile.value == null && !profileController.isLoading.value) {
      profileController.fetchProfile();
    }

    return Drawer(
      width: MediaQuery.of(context).size.width * .78,
      child: SafeArea(
        child: Column(
          children: [
            //================ HEADER ==================
            Container(
              height: 220,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xff2E3C97),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(120),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 18,
                    left: 18,
                    child: CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.transparent,
                      backgroundImage: AssetImage(logo2),
                    ),
                  ),

                  Positioned(
                    top: 16,
                    right: 16,
                    child: InkWell(
                      onTap: () => Get.back(),
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15), // circle background
                          border: Border.all(
                            color: Colors.white,
                            width: 1,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ),

                  Align(
                    alignment: Alignment.center,
                    child: Obx(() {
                      final rawName = profileController.restaurantName.value.trim();
                      final displayName = rawName.isNotEmpty
                          ? rawName
                          : (profileController.isLoading.value ? "Loading..." : "Restaurant");

                      final rawId = profileController.restaurantId.value.trim();
                      String displayId = "";
                      if (rawId.isNotEmpty) {
                        if (rawId.toLowerCase().startsWith("id:")) {
                          displayId = rawId;
                        } else if (rawId.toLowerCase().startsWith("rst")) {
                          displayId = "ID: $rawId";
                        } else if (int.tryParse(rawId) != null) {
                          displayId = "ID: RST${rawId.padLeft(3, '0')}";
                        } else {
                          displayId = "ID: $rawId";
                        }
                      }

                      final imageStr = profileController.profileImage.value.trim();
                      final fullImageUrl = ImageHelper.getImageUrl(imageStr);

                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 82,
                            height: 82,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white,
                                width: 2,
                              ),
                              color: Colors.white.withOpacity(0.15),
                            ),
                            child: ClipOval(
                              child: fullImageUrl != null && fullImageUrl.isNotEmpty
                                  ? (fullImageUrl.startsWith('assets/')
                                      ? Image.asset(
                                          fullImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            userProfile,
                                            fit: BoxFit.cover,
                                          ),
                                        )
                                      : Image.network(
                                          fullImageUrl,
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => Image.asset(
                                            userProfile,
                                            fit: BoxFit.cover,
                                          ),
                                        ))
                                  : Image.asset(
                                      userProfile,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              displayName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 21,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          if (displayId.isNotEmpty) ...[
                            const SizedBox(height: 4),
                            Text(
                              displayId,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ],
                      );
                    }),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  drawerItem(
                    SvgPicture.asset(
                      profileIcon,
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff2B3142),
                        BlendMode.srcIn,
                      ),
                    ),
                    "Restaurant Info",
                    onTap: () {
                      Get.back(); // Close the drawer fir
                      Get.to(() => profile_view.ProfileScreen());
                    },
                  ),
                  drawerItem(
                    Icons.account_balance,
                    "Bank Details",
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.to(() => BankDetailsScreen());
                    },
                  ),
                  drawerItem(
                    SvgPicture.asset(
                      addImageIcon,
                      width: 22,
                      height: 22,
                      colorFilter: const ColorFilter.mode(
                        Color(0xff2B3142),
                        BlendMode.srcIn,
                      ),
                    ),
                    "Products",
                    onTap: () {
                      Get.back();
                      Get.to(() => const ProductListScreen());
                    },
                  ),
                  drawerItem(
                    Icons.category_outlined,
                    "Categories",
                    onTap: () {
                      Get.back();
                      Get.to(() => const CategoryScreen());
                    },
                  ),
                  drawerItem(
                    Icons.assignment_outlined,
                    "Sales Reports",
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.to(() => SalesReportScreen());
                    },
                  ),

                  // drawerItem(Icons.person_outline, "Profile"),
                  drawerItem(
                    Icons.settings_outlined,
                    "Settings",
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.to(() => SettingsScreen());
                    },
                  ),
                  drawerItem(
  SvgPicture.asset(
    customerReviewIcon,
    width: 22,
    height: 22,
    colorFilter: const ColorFilter.mode(
      Color(0xff2B3142),
      BlendMode.srcIn,
    ),
  ),
  "Customer Review",
  onTap: () {
    Get.back();
    Get.to(() => CustomerReviewScreen());
  },
),
                  drawerItem(
                    Icons.feedback_outlined, 
                    "Feedbacks",
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.to(() => FeedbackScreen());
                    },
                    ),
                  drawerItem(
                    Icons.headset_mic_outlined, 
                    "Help & Support",
                    onTap: () {
                      Get.back(); // Close the drawer first
                      Get.to(() => HelpSupportSCreen());
                    },
                    ),

                  const Divider(),

                  drawerItem(
                    Icons.logout,
                    "Logout",
                    iconColor: Colors.red,
                    textColor: Colors.red,
                    arrowColor: Colors.red,
                    onTap: () {
    showLogoutDialog(context);
  },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerItem(
  dynamic icon,
  String title, {
  Color iconColor = const Color(0xff2B3142),
  Color textColor = const Color(0xff2B3142),
  Color arrowColor = Colors.grey,
  VoidCallback? onTap,
}) {
  return InkWell(
    onTap: onTap ?? () {},
    child: Container(
      height: 58,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            height: 28,
            child: Center(
              child: icon is IconData
                  ? Icon(
                      icon,
                      color: iconColor,
                      size: 22,
                    )
                  : icon,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: textColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          Icon(
            Icons.chevron_right,
            color: arrowColor,
          ),
        ],
      ),
    ),
  );
}
}