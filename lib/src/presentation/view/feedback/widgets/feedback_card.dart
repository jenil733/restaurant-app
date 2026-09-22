import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/data/models/feedback_model.dart';

class FeedbackCard extends StatelessWidget {
  final dynamic review;

  const FeedbackCard({
    super.key,
    required this.review,
  });

  @override
  Widget build(BuildContext context) {
    String name = "";
    String? imagePath;
    String time = "";
    String reviewText = "";
    double rating = 5.0;

    if (review is FeedbackItemModel) {
      final item = review as FeedbackItemModel;
      name = item.name;
      imagePath = item.image;
      time = item.time;
      reviewText = item.review;
      rating = item.rating;
    } else if (review is Map) {
      final map = review as Map;
      name = map["name"]?.toString() ?? "";
      imagePath = map["image"]?.toString();
      time = map["time"]?.toString() ?? "";
      reviewText = map["review"]?.toString() ?? "";
      final r = map["rating"];
      if (r is num) rating = r.toDouble();
    }

    final resolvedImg = ImageHelper.getImageUrl(imagePath);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header (Avatar, Name, Rating, Time)
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
                  child: resolvedImg != null && resolvedImg.isNotEmpty
                      ? (resolvedImg.startsWith('assets/')
                          ? Image.asset(
                              resolvedImg,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                homeStoreImg,
                                fit: BoxFit.cover,
                              ),
                            )
                          : Image.network(
                              resolvedImg,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.asset(
                                homeStoreImg,
                                fit: BoxFit.cover,
                              ),
                            ))
                      : Image.asset(
                          homeStoreImg,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name.isNotEmpty ? name : "Customer",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff1C2A3A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < rating.round() ? Icons.star : Icons.star_border,
                          size: 14,
                          color: const Color(0xffFFB800),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              if (time.isNotEmpty)
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
                    time,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          if (reviewText.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              "\"$reviewText\"",
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                color: Color(0xff333333),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
