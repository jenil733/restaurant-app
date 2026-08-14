import 'package:flutter/material.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.actionText,
    this.onActionPressed,
    this.onBackPressed,
  });

  final String title;
  final List<Widget>? actions;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:  AppColors.background,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,

      leadingWidth: 60,

      leading: Padding(
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: onBackPressed ?? () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: 35,
            height: 25,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(.06),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              size: 18,
              color: Color(0xff3A4A7A),
            ),
          ),
        ),
      ),

      titleSpacing: 8,

      title: Text(
        title,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),

      actions: [
        if (actionText != null)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: SizedBox(
              height: 34,
              child: ElevatedButton(
                onPressed: onActionPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xffFF8A3D),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionText!,
                  style:TextHelper.button.copyWith(
                    fontSize:14,
                    color:AppColors.white,
                  )
                ),
              ),
            ),
          ),
        ...?actions,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}