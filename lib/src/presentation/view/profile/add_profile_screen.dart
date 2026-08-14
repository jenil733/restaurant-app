import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/presentation/widgets/app_bar.dart';
import 'package:restaurant_app/src/presentation/widgets/button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final restaurantController =
      TextEditingController(text: "Kayal Restaurant");
  final ownerController =
      TextEditingController(text: "John Miller");
  final idController =
      TextEditingController(text: "RST001");
  final phoneController =
      TextEditingController(text: "+91 9876543212");
  final emailController =
      TextEditingController(text: "john@gmail.com");
  final cityController =
      TextEditingController(text: "Chennai");
  final streetController =
      TextEditingController(text: "T Nagar");
  final addressController =
      TextEditingController(text: "T Nagar");
  final pinController =
      TextEditingController(text: "600 001");
  final startTimeController =
      TextEditingController(text: "10:00 AM");
  final endTimeController =
      TextEditingController(text: "10:00 PM");

  final RxString restaurantType = "Non-Veg".obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: 'Profile',
        
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            Stack(
              alignment: Alignment.bottomRight,
              children: [
                const CircleAvatar(
                  radius: 45,
                  backgroundColor: Color(0xffD9D9D9),
                  child: Icon(
                    Icons.person,
                    size: 90,
                    color: Colors.black54,
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

            const SizedBox(height: 25),

            buildField(
              "Restaurant ID",
              idController,
              readOnly: true,
            ),

            buildField(
              "Restaurant Name",
              restaurantController,
              readOnly: true,
            ),

            buildField(
              "Owner Name",
              ownerController,
              readOnly: true,
            ),

            buildField(
              "Phone No",
              phoneController,
              readOnly: true,
            ),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Restaurant Type",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),

            const SizedBox(height: 8),

            Obx(
              () => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.textBackground,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: restaurantType.value,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(
                        value: "Veg",
                        child: Text("Veg"),
                      ),
                      DropdownMenuItem(
                        value: "Non-Veg",
                        child: Text("Non-Veg"),
                      ),
                    ],
                    onChanged: (value) {
                      restaurantType.value = value!;
                    },
                  ),
                ),
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

            CustomButton(
              text: "Update",
              onTap: () {
                // Update profile
              },
            ),
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
                controller.text = picked.format(context);
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

            // Different background colors
            fillColor: readOnly
                ? const Color(0xFFF2F2F7)
                : Colors.white,

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