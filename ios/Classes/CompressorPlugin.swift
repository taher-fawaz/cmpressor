import Flutter
import UIKit

public class CompressorPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "compressor", binaryMessenger: registrar.messenger())
    let instance = CompressorPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "compressVideo":
      guard let args = call.arguments as? [String: Any],
            let videoPath = args["inputPath"] as? String,
            let outputPath = args["outputPath"] as? String else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for compressVideo", details: nil))
        return
      }
      compressVideo(inputPath: videoPath, outputPath: outputPath, result: result)
    case "trimVideo":
      guard let args = call.arguments as? [String: Any],
            let videoPath = args["inputPath"] as? String,
            let outputPath = args["outputPath"] as? String,
            let startTime = args["startTime"] as? Double,
            let endTime = args["endTime"] as? Double else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Invalid arguments for trimVideo", details: nil))
        return
      }
      trimVideo(inputPath: videoPath, outputPath: outputPath, startTime: startTime, endTime: endTime, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  private func compressVideo(inputPath: String, outputPath: String, result: @escaping FlutterResult) {
    let avAsset = AVURLAsset(url: URL(fileURLWithPath: inputPath))
    let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetMediumQuality)!
    exportSession.outputURL = URL(fileURLWithPath: outputPath)
    exportSession.outputFileType = .mp4
    exportSession.exportAsynchronously {
      if exportSession.status == .completed {
        result(outputPath)
      } else {
        result(FlutterError(code: "COMPRESSION_FAILED", message: "Video compression failed", details: nil))
      }
    }
  }

  private func trimVideo(inputPath: String, outputPath: String, startTime: Double, endTime: Double, result: @escaping FlutterResult) {
    let avAsset = AVURLAsset(url: URL(fileURLWithPath: inputPath))
    let exportSession = AVAssetExportSession(asset: avAsset, presetName: AVAssetExportPresetPassthrough)!
    exportSession.outputURL = URL(fileURLWithPath: outputPath)
    exportSession.outputFileType = .mp4

    let start = CMTime(seconds: startTime, preferredTimescale: 600)
    let duration = CMTime(seconds: endTime - startTime, preferredTimescale: 600)
    exportSession.timeRange = CMTimeRange(start: start, duration: duration)

    exportSession.exportAsynchronously {
      if exportSession.status == .completed {
        result(outputPath)
      } else {
        result(FlutterError(code: "TRIMMING_FAILED", message: "Video trimming failed", details: nil))
      }
    }
  }
}