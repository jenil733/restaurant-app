import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';

class FeedbackCard extends StatelessWidget {
  final Map<String, dynamic> review;

  const FeedbackCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    final imagePath = review["image"] as String?;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header (Avatar, Name, Time)
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xffF37021),
                    width: 1.5,
                  ),
                ),
                child: ClipOval(
                  child: imagePath != null && imagePath.startsWith('http')
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            homeStoreImg,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset(
                          (imagePath != null && imagePath.isNotEmpty)
                              ? imagePath
                              : homeStoreImg,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Image.asset(
                            homeStoreImg,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.person,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  review["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xff1C2A3A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  review["time"] ?? "",
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          /// Review Text
          Text(
            "\"${review["review"] ?? ""}\"",
            style: const TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Color(0xff333333),
            ),
          ),
        ],
      ),
    );
  }
}
