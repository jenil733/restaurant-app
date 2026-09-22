import 'dart:io';
import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/image_helper.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final bool isVeg;
  final String originalPrice;
  final String discountedPrice;
  final String discountText;
  final String description;
  final String? image;

  const ProductCard({
    super.key,
    required this.title,
    required this.isVeg,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountText,
    required this.description,
    this.image,
  });

  Widget _buildProductImage() {
    if (image != null && image!.trim().isNotEmpty && image!.trim().toLowerCase() != 'null') {
      final img = image!.trim();
      if (img.startsWith('assets/')) {
        return Image.asset(
          img,
          width: 140,
          height: 125,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Image.asset(
            product,
            width: 140,
            height: 125,
            fit: BoxFit.cover,
          ),
        );
      } else {
        try {
          final file = File(img);
          if (file.existsSync()) {
            return Image.file(
              file,
              width: 140,
              height: 125,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Image.asset(
                product,
                width: 140,
                height: 125,
                fit: BoxFit.cover,
              ),
            );
          }
        } catch (_) {}

        final resolvedUrl = ImageHelper.getImageUrl(img);
        if (resolvedUrl != null && resolvedUrl.isNotEmpty) {
          return Image.network(
            resolvedUrl,
            width: 140,
            height: 125,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              product,
              width: 140,
              height: 125,
              fit: BoxFit.cover,
            ),
          );
        }
      }
    }

    return Image.asset(
      product,
      width: 140,
      height: 125,
      fit: BoxFit.cover,
    );
  }

  @override
  Widget build(BuildContext context) {
    final badgeColor = isVeg ? Colors.green : Colors.red;

    return Container(
      constraints: const BoxConstraints(minHeight: 145),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: _buildProductImage(),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                /// title + icon
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextHelper.protext.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      width: 16,
                      height: 16,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: badgeColor, width: 1.5),
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: badgeColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 2),

                Text(isVeg ? "Veg" : "Non-Veg", style: TextHelper.prosubtext),

                const SizedBox(height: 4),

                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      "₹$originalPrice",
                      style: TextHelper.provalue1.copyWith(
                        color: AppColors.textBackground,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.textBackground,
                      ),
                    ),
                    Text("₹$discountedPrice", style: TextHelper.provalue),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffE8F8EC),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        discountText,
                        style: TextHelper.discount.copyWith(
                          color: Colors.green,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                Text(
                  "Description",
                  style: TextHelper.discount.copyWith(
                    fontWeight: FontWeight.w900,
                    color: AppColors.textprimary,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextHelper.discount.copyWith(
                    fontWeight: FontWeight.w100,
                    color: AppColors.subText,
                    height: 1.2,
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
