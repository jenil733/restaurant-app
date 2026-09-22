import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/data/models/update_profile_model.dart';
import 'package:restaurant_app/src/presentation/controller/auth/sign_in_controller.dart';
import 'package:restaurant_app/src/presentation/controller/profile_controller.dart';
import 'package:restaurant_app/src/presentation/view/products/widgets/product_dropdown.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final ProfileController controller;

  late final TextEditingController restaurantController;
  late final TextEditingController ownerController;
  late final TextEditingController idController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController cityController;
  late final TextEditingController streetController;
  late final TextEditingController addressController;
  late final TextEditingController pinController;
  late final TextEditingController startTimeController;
  late final TextEditingController endTimeController;

  final RxString restaurantType = "Non-Veg".obs;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    controller = Get.isRegistered<ProfileController>()
        ? Get.find<ProfileController>()
        : Get.put(ProfileController());

    restaurantController = TextEditingController(text: controller.restaurantName.value);
    ownerController = TextEditingController(text: controller.ownerName.value);
    idController = TextEditingController(text: controller.restaurantId.value);
    phoneController = TextEditingController(text: controller.mobile.value);
    emailController = TextEditingController(text: controller.email.value);
    cityController = TextEditingController(text: controller.city.value);
    streetController = TextEditingController(text: controller.street.value);
    addressController = TextEditingController(text: controller.address.value);
    pinController = TextEditingController(text: controller.pincode.value);
    startTimeController = TextEditingController(text: controller.startTime.value);
    endTimeController = TextEditingController(text: controller.endTime.value);
    restaurantType.value = controller.foodType.value.isNotEmpty ? controller.foodType.value : "Non-Veg";
  }

  @override
  void dispose() {
    restaurantController.dispose();
    ownerController.dispose();
    idController.dispose();
    phoneController.dispose();
    emailController.dispose();
    cityController.dispose();
    streetController.dispose();
    addressController.dispose();
    pinController.dispose();
    startTimeController.dispose();
    endTimeController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Error picking image: $e");
    }
  }

  Future<void> _submitUpdate() async {
    final request = UpdateProfileRequestModel(
      restaurantName: restaurantController.text.trim(),
      ownerName: ownerController.text.trim(),
      phone: phoneController.text.trim(),
      email: emailController.text.trim(),
      city: cityController.text.trim(),
      street: streetController.text.trim(),
      address: addressController.text.trim(),
      pincode: pinController.text.trim(),
      startTime: startTimeController.text.trim(),
      endTime: endTimeController.text.trim(),
      foodType: restaurantType.value,
      imagePath: _selectedImage?.path,
    );

    await controller.updateProfile(request);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: 'Edit Profile',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xffD9D9D9),
                      border: Border.all(color: Colors.orange.shade200, width: 2),
                    ),
                    child: ClipOval(
                      child: _selectedImage != null
                          ? Image.file(_selectedImage!, fit: BoxFit.cover)
                          : (controller.profileImage.value.isNotEmpty &&
                                  (controller.profileImage.value.startsWith('http://') ||
                                      controller.profileImage.value.startsWith('https://'))
                              ? Image.network(
                                  controller.profileImage.value,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.person,
                                    size: 70,
                                    color: Colors.black54,
                                  ),
                                )
                              : const Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.black54,
                                )),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.orange,
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.orange,
                      size: 18,
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 25),
            if (idController.text.isNotEmpty)
              buildField(
                "Restaurant ID",
                idController,
                readOnly: true,
              ),
            buildField(
              "Restaurant Name",
              restaurantController,
            ),
            buildField(
              "Owner Name",
              ownerController,
            ),
            buildField(
              "Phone No",
              phoneController,
            ),
            Obx(
              () => ProductDropdown(
                title: "Restaurant Type",
                hint: "Select or enter restaurant type",
                value: restaurantType.value,
                items: SignInController.availableRestaurantTypes,
                onChanged: (value) {
                  if (value != null && value.isNotEmpty) {
                    restaurantType.value = value;
                  }
                },
              ),
            ),
            const SizedBox(height: 18),
            buildField(
              "Email",
              emailController,
            ),
            buildField(
              "City",
              cityController,
            ),
            buildField(
              "Street",
              streetController,
            ),
            buildField(
              "Address",
              addressController,
            ),
            buildField(
              "Pincode",
              pinController,
            ),
            Row(
              children: [
                Expanded(
                  child: buildTimeField(
                    context,
                    "Start Time",
                    startTimeController,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: buildTimeField(
                    context,
                    "End Time",
                    endTimeController,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            Obx(
              () => CustomButton(
                text: "Update",
                isLoading: controller.isUpdating.value,
                onTap: _submitUpdate,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget buildTimeField(
    BuildContext context,
    String title,
    TextEditingController controller,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                final formatted = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
                controller.text = formatted;
              }
            },
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 16,
              ),
              suffixIcon: const Icon(
                Icons.access_time,
                color: Colors.grey,
                size: 22,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBackground,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBackground,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildField(
    String title,
    TextEditingController controller, {
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            readOnly: readOnly,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? const Color(0xFFF2F2F7) : Colors.white,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 16,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBackground,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.textBackground,
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}