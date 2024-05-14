import 'compressor_platform_interface.dart';

class Compressor {
  static Future<String?> compressVideo(String inputPath, String outputPath) {
    return CompressorPlatform.instance.compressVideo(inputPath, outputPath);
  }
}
