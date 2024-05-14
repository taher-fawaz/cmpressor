import 'compressor_platform_interface.dart';

class Compressor {
  Future<String?> compressVideo(String inputPath, String outputPath) {
    return CompressorPlatform.instance.compressVideo(inputPath, outputPath);
  }
}
