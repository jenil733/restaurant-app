import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppEmbeddedImage extends StatefulWidget {
  const AppEmbeddedImage({
    required this.asset,
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.fallback,
  });

  final String asset;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? fallback;

  @override
  State<AppEmbeddedImage> createState() => _AppEmbeddedImageState();
}

class _AppEmbeddedImageState extends State<AppEmbeddedImage> {
  late Future<Uint8List> _imageBytes = _loadImage();

  @override
  void didUpdateWidget(covariant AppEmbeddedImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.asset != widget.asset) {
      _imageBytes = _loadImage();
    }
  }

  Future<Uint8List> _loadImage() async {
    final source = await rootBundle.loadString(widget.asset);
    final match = RegExp(r'base64,([^"]+)').firstMatch(source);

    if (match == null) {
      throw FormatException('No embedded image found in ${widget.asset}');
    }

    return base64Decode(match.group(1)!);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: FutureBuilder<Uint8List>(
        future: _imageBytes,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Image.memory(
              snapshot.data!,
              width: widget.width,
              height: widget.height,
              fit: widget.fit,
              gaplessPlayback: true,
              errorBuilder: (_, _, _) => _fallback(),
            );
          }

          return _fallback();
        },
      ),
    );
  }

  Widget _fallback() {
    return widget.fallback ?? const ColoredBox(color: Color(0xFFF7F3EF));
  }
}
