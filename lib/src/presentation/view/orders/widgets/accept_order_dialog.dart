import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AcceptOrderDialog {
  static Future<void> show({
    required VoidCallback onAccept,
  }) async {
    await Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Are you sure ?",
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 10),

              Divider(
                color: Colors.grey.shade300,
                thickness: 1,
                height: 1,
              ),

              const SizedBox(height: 16),

              Text(
                "You want to",
                style: GoogleFonts.poppins(
                  color: const Color(0xFF8E8E93),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                "Accept this Order?",
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  color: const Color(0xFF555555),
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(46),
                        side: BorderSide(
                          color: Colors.grey.shade300,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: GoogleFonts.poppins(
                          color: const Color(0xFF8E8E93),
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        onAccept();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF22C55E),
                        elevation: 0,
                        minimumSize: const Size.fromHeight(46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        "Accept",
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
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