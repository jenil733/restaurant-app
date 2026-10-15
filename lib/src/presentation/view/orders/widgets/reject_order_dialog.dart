import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';

class RejectOrderDialog {
  static Future<void> show({
    required Function(String reason) onSubmit,
  }) async {
    final TextEditingController reasonController = TextEditingController();

    await Get.dialog(
      Dialog(
        backgroundColor: AppColors.background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure ?",
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
              ),

              const SizedBox(height: 12),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Description",
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              TextField(
                controller: reasonController,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  hintText: "Enter",
                  hintStyle: GoogleFonts.poppins(fontSize: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (reasonController.text.trim().isEmpty) {
                          Get.snackbar(
                            "Error",
                            "Please enter description",
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          return;
                        }

                        Get.back();

                        onSubmit(
                          reasonController.text.trim(),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize:
                            const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Submit",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}