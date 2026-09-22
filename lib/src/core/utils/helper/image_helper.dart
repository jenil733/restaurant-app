import 'package:restaurant_app/src/core/const/api_routes.dart';

class ImageHelper {
  /// Builds a valid image URL handling full URLs, relative storage paths, and legacy domains.
  static String? getImageUrl(String? path) {
    if (path == null) return null;
    final trimmed = path.trim();
    if (trimmed.isEmpty || trimmed.toLowerCase() == 'null') return null;

    if (trimmed.startsWith('assets/')) return trimmed;

    if (trimmed.startsWith('http://') || trimmed.startsWith('https://')) {
      if (trimmed.contains('pickmysnacks.com') ||
          trimmed.contains('localhost') ||
          trimmed.contains('127.0.0.1')) {
        final uri = Uri.tryParse(trimmed);
        if (uri != null) {
          final uriPath = uri.path;
          if (uriPath.contains('/storage/')) {
            final afterStorage = uriPath.substring(uriPath.indexOf('/storage/') + 9);
            return '${ApiRoutes.imageBaseURL}$afterStorage';
          }
          final clean = uriPath.startsWith('/') ? uriPath.substring(1) : uriPath;
          return 'http://64.227.170.206/kayal.com/public/$clean';
        }
      }
      return trimmed;
    }

    String clean = trimmed;
    if (clean.startsWith('/')) {
      clean = clean.substring(1);
    }

    if (clean.startsWith('public/storage/')) {
      clean = clean.substring(15);
      return '${ApiRoutes.imageBaseURL}$clean';
    } else if (clean.startsWith('storage/')) {
      clean = clean.substring(8);
      return '${ApiRoutes.imageBaseURL}$clean';
    } else if (clean.startsWith('public/')) {
      clean = clean.substring(7);
      return 'http://64.227.170.206/kayal.com/public/$clean';
    } else if (clean.startsWith('uploads/')) {
      return 'http://64.227.170.206/kayal.com/public/$clean';
    }

    return '${ApiRoutes.imageBaseURL}$clean';
  }
}
