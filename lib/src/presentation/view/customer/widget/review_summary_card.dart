import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ReviewSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String icon; // SVG asset
  final Color iconColor;
  final Color iconBg;
  final bool hasStar;

  const ReviewSummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    this.hasStar = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Color(0xff1C2A3A),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              Container(
                width: 32,
                height: 32,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: SvgPicture.asset(
                  icon,
                  colorFilter: ColorFilter.mode(
                    iconColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ],
          ),

          const Spacer(),

          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                if (hasStar) ...[
                  const Icon(Icons.star, color: Color(0xffFFC107), size: 22),
                  const SizedBox(width: 4),
                ],
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xff1C2A3A),
                    fontWeight: FontWeight.w700,
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