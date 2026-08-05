import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:restaurant_app/src/core/const/app_color.dart';
import 'package:restaurant_app/src/core/const/app_images.dart';

class AppProfileImage extends StatefulWidget {
  const AppProfileImage({super.key, this.size = 76});

  final double size;

  @override
  State<AppProfileImage> createState() => _AppProfileImageState();
}

class _AppProfileImageState extends State<AppProfileImage> {
  late final Future<Uint8List> _profileBytes = _loadEmbeddedProfileImage();

  Future<Uint8List> _loadEmbeddedProfileImage() async {
    final svgSource = await rootBundle.loadString(profile);
    final match = RegExp(r'base64,([^"]+)').firstMatch(svgSource);

    if (match == null) {
      throw const FormatException('Embedded profile image was not found');
    }

    return base64Decode(match.group(1)!);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: widget.size,
      decoration: BoxDecoration(
        color: AppColors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      clipBehavior: Clip.antiAlias,
      child: FutureBuilder<Uint8List>(
        future: _profileBytes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              key: const Key('restaurant-profile-image'),
              fit: BoxFit.cover,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _fallbackIcon(),
            );
          }

          return _fallbackIcon();
        },
      ),
    );
  }

  Widget _fallbackIcon() {
    return Padding(
      padding: EdgeInsets.all(widget.size * 0.12),
      child: SvgPicture.asset(profileIcon, fit: BoxFit.contain),
    );
  }
}
