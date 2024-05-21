import 'compressor_platform_interface.dart';

class Compressor {
  static Future<String?> compressVideo(String inputPath, String outputPath) {
    return CompressorPlatform.instance.compressVideo(inputPath, outputPath);
  }

  static Future<String?> trimVideo(
      String inputPath, String outputPath, double startTime, double endTime) {
    return CompressorPlatform.instance
        .trimVideo(inputPath, outputPath, startTime, endTime);
  }
}
