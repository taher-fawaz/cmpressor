import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'compressor_method_channel.dart';

abstract class CompressorPlatform extends PlatformInterface {
  /// Constructs a CompressorPlatform.
  CompressorPlatform() : super(token: _token);

  static final Object _token = Object();

  static CompressorPlatform _instance = MethodChannelCompressor();

  /// The default instance of [CompressorPlatform] to use.
  ///
  /// Defaults to [MethodChannelCompressor].
  static CompressorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [CompressorPlatform] when
  /// they register themselves.
  static set instance(CompressorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> compressVideo(String inputPath, String outputPath) {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
