import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final bool isVeg;
  final String originalPrice;
  final String discountedPrice;
  final String discountText;
  final String description;

  const ProductCard({
    super.key,
    required this.title,
    required this.isVeg,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountText,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isVeg ? Colors.green : Colors.red;

    return Container(
      height: 145,
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
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              product,
              width: 150,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: SizedBox(
              height: 110,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// title + icon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextHelper.protext.copyWith(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          ),
                        ),
                      ),

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

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      Text("₹$originalPrice", style: TextHelper.provalue1.copyWith(
                        color:AppColors.textBackground,
                        decoration: TextDecoration.lineThrough,
                        decorationColor: AppColors.textBackground,
                      )),
                      const SizedBox(width: 6),
                      Text("₹$discountedPrice", style: TextHelper.provalue),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
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

                  Expanded(
                    child: Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextHelper.discount.copyWith(
                        fontWeight: FontWeight.w100,
                        color: AppColors.subText,
                        height: 1.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
