import 'package:flutter_test/flutter_test.dart';
import 'package:compressor/compressor.dart';
import 'package:compressor/compressor_platform_interface.dart';
import 'package:compressor/compressor_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockCompressorPlatform
    with MockPlatformInterfaceMixin
    implements CompressorPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final CompressorPlatform initialPlatform = CompressorPlatform.instance;

  test('$MethodChannelCompressor is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelCompressor>());
  });

  test('getPlatformVersion', () async {
    Compressor compressorPlugin = Compressor();
    MockCompressorPlatform fakePlatform = MockCompressorPlatform();
    CompressorPlatform.instance = fakePlatform;

    expect(await compressorPlugin.getPlatformVersion(), '42');
  });
}
