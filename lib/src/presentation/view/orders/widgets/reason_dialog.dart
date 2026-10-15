import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ReasonDialog {
  static void show(String remark) {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Remark",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 8),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  remark,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
              ),

              const SizedBox(height: 22),

              Center(
                child: SizedBox(
                  width: 135,
                  height: 42,
                  child: OutlinedButton(
                    onPressed: () => Get.back(),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: Colors.red,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      "Close",
                      style: GoogleFonts.poppins(
                        color: Colors.red,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}