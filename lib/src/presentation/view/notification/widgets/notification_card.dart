import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/data/models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationItemModel item;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final VoidCallback? onActionTap;

  const NotificationCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onDelete,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final meta = _getCategoryMeta(item.type);

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.red.withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              "Delete",
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: item.isRead
                  ? Colors.white
                  : const Color(0xFFFFF9F5), // subtle warm orange tint for unread
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: item.isRead
                    ? const Color(0xFFF0F1F5)
                    : AppColors.primary.withValues(alpha: 0.35),
                width: item.isRead ? 1.0 : 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: item.isRead
                      ? Colors.black.withValues(alpha: 0.03)
                      : AppColors.primary.withValues(alpha: 0.07),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Icon with Circle Background
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: meta.bgColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: meta.iconColor.withValues(alpha: 0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          meta.icon,
                          color: meta.iconColor,
                          size: 22,
                        ),
                      ),
                    ),
                    if (!item.isRead)
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Row: Type Badge + Time Ago
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: meta.bgColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              meta.tagText.toUpperCase(),
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: meta.iconColor,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 12,
                                color: Colors.grey.shade500,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                item.timeAgo,
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        item.title,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: item.isRead
                              ? FontWeight.w600
                              : FontWeight.w700,
                          color: const Color(0xFF1F2937),
                          height: 1.3,
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Message
                      Text(
                        item.message,
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF4B5563),
                          height: 1.4,
                        ),
                      ),

                      // Optional Action Button / Chip
                      if (item.actionText != null &&
                          item.actionText!.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: onActionTap ?? onTap,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: meta.iconColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: meta.iconColor.withValues(alpha: 0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.actionText!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: meta.iconColor,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                  color: meta.iconColor,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _CategoryMeta _getCategoryMeta(String type) {
    switch (type.toLowerCase()) {
      case 'order':
        return _CategoryMeta(
          icon: Icons.receipt_long_rounded,
          iconColor: const Color(0xFFFF8A3D),
          bgColor: const Color(0xFFFFF1E8),
          tagText: 'Order',
        );
      case 'store':
        return _CategoryMeta(
          icon: Icons.store_mall_directory_rounded,
          iconColor: const Color(0xFF2E3C97),
          bgColor: const Color(0xFFEEF1FB),
          tagText: 'Store',
        );
      case 'review':
        return _CategoryMeta(
          icon: Icons.star_rounded,
          iconColor: const Color(0xFFEAB308),
          bgColor: const Color(0xFFFEF9C3),
          tagText: 'Review',
        );
      case 'feedback':
        return _CategoryMeta(
          icon: Icons.chat_bubble_outline_rounded,
          iconColor: const Color(0xFF8B5CF6),
          bgColor: const Color(0xFFF5F3FF),
          tagText: 'Feedback',
        );
      case 'payout':
        return _CategoryMeta(
          icon: Icons.account_balance_wallet_rounded,
          iconColor: const Color(0xFF10B981),
          bgColor: const Color(0xFFECFDF5),
          tagText: 'Payout',
        );
      case 'system':
      default:
        return _CategoryMeta(
          icon: Icons.notifications_active_rounded,
          iconColor: const Color(0xFF3B82F6),
          bgColor: const Color(0xFFEFF6FF),
          tagText: 'Alert',
        );
    }
  }
}

class _CategoryMeta {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String tagText;

  _CategoryMeta({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.tagText,
  });
}
