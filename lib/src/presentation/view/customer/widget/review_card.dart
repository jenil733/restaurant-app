import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import '../../../../data/models/reviews_model.dart';

class ReviewCard extends StatelessWidget {
  final ReviewItemModel review;
  final VoidCallback? onReply;
  final bool showReplyButton;

  const ReviewCard({
    super.key,
    required this.review,
    this.onReply,
    this.showReplyButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final imgUrl = ImageHelper.getImageUrl(review.image);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          /// Header
          Row(
            children: [
              ClipOval(
                child: Container(
                  width: 44,
                  height: 44,
                  color: Colors.grey.shade200,
                  child: imgUrl != null && imgUrl.isNotEmpty
                      ? (imgUrl.startsWith('assets/')
                          ? Image.asset(
                              imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 26,
                              ),
                            )
                          : Image.network(
                              imgUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.person,
                                color: Colors.grey,
                                size: 26,
                              ),
                            ))
                      : const Icon(
                          Icons.person,
                          color: Colors.grey,
                          size: 26,
                        ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          Icons.star,
                          size: 18,
                          color: i < review.rating.round()
                              ? Colors.amber
                              : Colors.grey.shade300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              if (review.time.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    review.time,
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          Divider(color: Colors.grey.shade300),

          const SizedBox(height: 10),

          if (review.review.isNotEmpty)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "\"${review.review}\"",
                style: const TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: Color(0xff333333),
                ),
              ),
            ),

          if (review.reply != null && review.reply!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xffF7F8FA),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Restaurant Reply",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xffFF8A3D),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    review.reply!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (showReplyButton) ...[
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onReply,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffFF8A3D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Send Reply",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}