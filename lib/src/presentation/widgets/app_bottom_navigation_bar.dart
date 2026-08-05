import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';
import 'package:restaurant_app/src/core/utils/helper/texthelper.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  }) : assert(currentIndex >= 0 && currentIndex < 4);

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavigationItem(label: 'Home', icon: homeIcon),
    _NavigationItem(label: 'Orders', icon: boxIcon),
    _NavigationItem(label: 'Add', icon: addImageIcon),
    _NavigationItem(label: 'Profile', icon: profileIcon),
  ];

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: AppColors.textprimary.withValues(alpha: 0.07),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        minimum: const EdgeInsets.fromLTRB(16, 7, 16, 7),
        child: SizedBox(
          height: 48,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const pillWidth = 104.0;
              final cellWidth = constraints.maxWidth / _items.length;
              final targetLeft =
                  (cellWidth * currentIndex + (cellWidth - pillWidth) / 2)
                      .clamp(0.0, constraints.maxWidth - pillWidth);

              return Stack(
                children: [
                  Row(
                    children: [
                      for (var index = 0; index < _items.length; index++)
                        Expanded(
                          child: _BottomNavigationItem(
                            item: _items[index],
                            isSelected: currentIndex == index,
                            onTap: () => onTap(index),
                          ),
                        ),
                    ],
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 440),
                    curve: Curves.easeInOutCubicEmphasized,
                    left: targetLeft,
                    top: 1,
                    width: pillWidth,
                    height: 46,
                    child: IgnorePointer(
                      child: _SelectedNavigationPill(
                        item: _items[currentIndex],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _BottomNavigationItem extends StatelessWidget {
  const _BottomNavigationItem({
    required this.item,
    required this.isSelected,
    required this.onTap,
  });

  final _NavigationItem item;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: item.label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          key: Key('bottom-navigation-${item.label.toLowerCase()}'),
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Center(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutCubic,
              opacity: isSelected ? 0 : 1,
              child: SvgPicture.asset(
                item.icon,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.textprimary,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SelectedNavigationPill extends StatelessWidget {
  const _SelectedNavigationPill({required this.item});

  final _NavigationItem item;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF9B59), AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.28),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          transitionBuilder: (child, animation) {
            final slide = Tween<Offset>(
              begin: const Offset(0.12, 0),
              end: Offset.zero,
            ).animate(animation);
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: slide,
                child: ScaleTransition(
                  scale: Tween<double>(begin: 0.92, end: 1).animate(animation),
                  child: child,
                ),
              ),
            );
          },
          child: Row(
            key: ValueKey(item.label),
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                item.icon,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 7),
              Flexible(
                child: Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextHelper.button.copyWith(
                    color: AppColors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavigationItem {
  const _NavigationItem({required this.label, required this.icon});

  final String label;
  final String icon;
}
