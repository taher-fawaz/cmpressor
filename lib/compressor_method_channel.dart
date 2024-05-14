import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'compressor_platform_interface.dart';

/// An implementation of [CompressorPlatform] that uses method channels.
class MethodChannelCompressor extends CompressorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('video_compression');
  @override
  Future<String?> compressVideo(String inputPath, String outputPath) async {
    try {
      final Map<String, dynamic> params = {
        'inputPath': inputPath,
        'outputPath': outputPath,
      };
      final String? result =
          await methodChannel.invokeMethod('compressVideo', params);
      return result;
    } on PlatformException catch (e) {
      return 'Error: ${e.message}';
    }
  }
}
