package com.example.compressor;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import java.io.File;

import android.os.Environment;
import com.arthenica.mobileffmpeg.Config;
import com.arthenica.mobileffmpeg.FFmpeg;
/** CompressorPlugin */
public class CompressorPlugin implements FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private MethodChannel channel;

  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "video_compression");
    channel.setMethodCallHandler(this);
  }

  @Override
  public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
    switch (call.method) {
      case "compressVideo":
        String videoPath = call.argument("inputPath");
        String outputPath = call.argument("outputPath");
        String compressedFilePath = VideoCompressor.compressVideo(videoPath, outputPath);
        result.success(compressedFilePath); // Return compressed video file path
        break;
      case "trimVideo":
        String inputPath = call.argument("inputPath");
        String trimOutputPath = call.argument("outputPath");
        double startTime = call.argument("startTime");
        double endTime = call.argument("endTime");
        String trimmedFilePath = VideoCompressor.trimVideo(inputPath, trimOutputPath, startTime, endTime);
        result.success(trimmedFilePath); // Return trimmed video file path
        break;
      default:
        result.notImplemented();
        break;
    }
  }
  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    channel.setMethodCallHandler(null);
  }
}


class VideoCompressor {
  public static String compressVideo(String videoPath, String outputPath) {
      if (videoPath == null || videoPath.isEmpty()) {
          return null; // Handle null or empty video path
      }

      // Create the output directory if it doesn't exist
      File outputDir = new File(outputPath).getParentFile();
      if (!outputDir.exists()) {
          outputDir.mkdirs();
      }

      // Construct the FFmpeg command to compress the video
      // You can adjust the compression settings as needed
      String[] cmd = new String[]{"-y", "-i", videoPath, "-c:v", "mpeg4", "-b:v", "1M", "-c:a", "aac", outputPath};

      // Execute the FFmpeg command
      int rc = FFmpeg.execute(cmd);

      if (rc == Config.RETURN_CODE_SUCCESS) {
          return outputPath;
      } else {
          // Handle compression failure
       
          return null;
      }
  }

  public static String trimVideo(String videoPath, String outputPath, double startTime, double endTime) {
    if (videoPath == null || videoPath.isEmpty()) {
      return null; // Handle null or empty video path
    }

    // Create the output directory if it doesn't exist
    File outputDir = new File(outputPath).getParentFile();
    if (!outputDir.exists()) {
      outputDir.mkdirs();
    }

    // Construct the FFmpeg command to trim the video
    String[] cmd = new String[]{"-y", "-i", videoPath, "-ss", String.valueOf(startTime), "-to", String.valueOf(endTime), "-c", "copy", outputPath};

    // Execute the FFmpeg command
    int rc = FFmpeg.execute(cmd);

    if (rc == Config.RETURN_CODE_SUCCESS) {
      return outputPath;
    } else {
      return null; // Handle trimming failure
    }
  }
}