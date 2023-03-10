import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environment {
  static String get fileName {
    if (kReleaseMode) {
      print('release mode');
      return '.env.production';
    }

    print('debug mode');
    return '.env.development';
  }

  static String get apiUrl {
    return dotenv.env['API_URL'] ?? '';
  }

  static String get mapUrl {
    return dotenv.env['MAP_URL'] ?? '';
  }

  static String get metaUrl {
    return dotenv.env['META_URL'] ?? '';
  }

  static String get cdnUrl {
    return dotenv.env['CDN_URL'] ?? '';
  }

  static String get prUrl {
    return dotenv.env['PR_URL'] ?? '';
  }

  static bool isDev() {
    return !kReleaseMode;
  }
}
