import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class StoreVerificationCard extends StatelessWidget {
  const StoreVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7F2), // Light orange background similar to image
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Placeholder for the store image (you can replace with Image.asset if you have the image)
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
    homeStoreImg,
    width: 100,
    height: 100,
    fit: BoxFit.cover,
  ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.hourglass_empty, color: Colors.white, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Store Verification\nin Progress',
                            style: TextHelper.heading2.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textprimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your restaurant has been submitted successfully. We will be reviewing your documents and details.',
                      style: TextHelper.heading2.copyWith(
                        fontSize: 11,
                        color: AppColors.textprimary.withOpacity(0.7),
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.primary.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.access_time, size: 16, color: AppColors.textprimary),
                    const SizedBox(width: 6),
                    Text(
                      'Estimated Approval',
                      style: TextHelper.heading2.copyWith(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textprimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text.rich(
                  TextSpan(
                    text: 'Within ',
                    style: TextHelper.heading2.copyWith(
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                    children: [
                      TextSpan(
                        text: '24',
                        style: TextHelper.heading2.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                      TextSpan(
                        text: ' Hours',
                        style: TextHelper.heading2.copyWith(
                          fontSize: 14,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RejectionNoteCard extends StatelessWidget {
  final String reason;
  const RejectionNoteCard({super.key, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E6),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Note:',
            style: TextHelper.heading2.copyWith(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '⚠️ Your FSSAI Certificate Has Been Rejected By Admin.',
            style: TextHelper.heading2.copyWith(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textprimary,
            ),
          ),
          const SizedBox(height: 4),
          Text.rich(
            TextSpan(
              text: 'Reason: ',
              style: TextHelper.heading2.copyWith(
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: reason,
                  style: TextHelper.heading2.copyWith(
                    fontSize: 12,
                    color: AppColors.textprimary,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
