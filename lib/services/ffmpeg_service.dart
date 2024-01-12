import 'dart:io';

import 'package:ffmpeg_kit_flutter_video/ffmpeg_session.dart';
import 'package:ffmpeg_kit_flutter_video/ffprobe_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffprobe_session.dart';
import 'package:ffmpeg_kit_flutter_video/level.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter_video/ffmpeg_kit_config.dart';
import 'package:ffmpeg_kit_flutter_video/return_code.dart';
import 'package:ffmpeg_kit_flutter_video/session_state.dart';
import 'package:flutter/cupertino.dart';

class FFmpegService {
  static Future<ImageDimensions> getImageDimensions(String imagePath) async {
    // Run ffprobe command to get the image information
    final arguments = [
      '-v',
      'error',
      '-select_streams',
      'v:0',
      '-show_entries',
      'stream=width,height',
      '-of',
      'csv=p=0',
      imagePath
    ];

    FFprobeSession ffprobeSession =
        await FFprobeKit.executeWithArguments(arguments);
    SessionState sessionState = await ffprobeSession.getState();
    if (sessionState == SessionState.completed) {
      String? output = await ffprobeSession.getAllLogsAsString();
      // Parse the output to get the width and height
      List<String>? dimensions = output?.trim().split(',');
      if (dimensions == null || dimensions.length < 2) {
        throw Exception('获取宽高失败');
      } else {
        int width = int.parse(dimensions[0]);
        int height = int.parse(dimensions[1]);

        return ImageDimensions(width, height);
      }
    } else {
      throw Exception('Failed to get image dimensions');
    }
  }

  static Future<void> generateVideoFromImages(
      List<String> imagePaths, String outputFilePath,
      {int fps = 30}) async {
    try {
      // if (imagePaths.isEmpty) {
      //   throw Exception("无图片");
      // }
      // 设置 ffmpeg 环境变量和日志级别
      await FFmpegKitConfig.init();
      FFmpegKitConfig.enableLogCallback((log) {
        if (log.getLevel() == Level.avLogError) {
          debugPrint("ffmpeg 错误: ${log.getMessage()}");
          throw Exception("FFmpeg Error: ${log.getMessage()}");
        } else {
          debugPrint("ffmpeg log: ${log.getMessage()}");
        }
      });
      await FFmpegKitConfig.enableLogs();
      await FFmpegKitConfig.setLogLevel(Level.avLogVerbose);

      // // 获取照片宽高信息
      // ImageDimensions imageDimensions =
      //     await getImageDimensions(imagePaths.first);

      // 它将以 25 帧每秒的帧率（-framerate 25）处理一系列图片文件（-i "$imageDir*.jpg"）并将它们合并为一个视频。
      // 输出视频使用 mpeg4 编解码器（-c:v mpeg4），采用 yuv420p 像素格式（-pix_fmt yuv420p）。
      // 视频的长度是 30 秒（-t 30），输出的文件路径是 outputFilePath。
      // debugPrint("将图片写入管道");
      // String? pipe = await FFmpegKitConfig.registerNewFFmpegPipe();
      // if (pipe == null) {
      //   throw Exception("FFmpeg Error: 管道生成失败");
      // }
      // for (String path in imagePaths) {
      //   debugPrint("图片地址：$path");
      //   int? t = await FFmpegKitConfig.writeToPipe(path, pipe);
      //   debugPrint("写入结果：$t");
      // }
      // FFmpegKitConfig.closeFFmpegPipe(pipe);
      // 创建 FFmpeg 命令
      // ffmpeg -framerate 30 -i a.jpg -i b.jpg -i c.jpg -c:v libx264 -profile:v high -crf 20 -pix_fmt yuv420p output.mp4
      List<String> command = [];
      command.addAll(["-hide_banner", "-y"]);
      command.addAll([
        "-framerate",
        "1",
        // "-r",
        // "5"
      ]);

      for (String path in imagePaths) {
        command.addAll([
          '-i',
          path, // 指定输入的图片路径
        ]);
      }
      command.addAll([
        // "-r",
        // "30",
        //   "-c:v",
        //   "libx264",
        //   "-pix_fmt",
        //   "yuv420p",
        //   "-vsync",
        //   "2",
        //   "-async",
        //   "1",
        //   // "-t",
        //   // "${imagePaths.length / 2}",
        //   outputFilePath
        // ]);

        '-t', "${imagePaths.length}",
        '-c:v',
        'mpeg4',
        '-pix_fmt',
        'yuv420p',
        '-crf',
        '20',
        '-preset',
        'ultrafast',
        outputFilePath
      ]);

      // command.addAll([
      //   "-framerate",
      //   "0.5",
      //   '-f',
      //   'image2pipe',
      //   "-i",
      //   pipe,
      //   // "-r",
      //   // "$fps",
      //   "-c:v",
      //   "mpeg4",
      //   "-pix_fmt",
      //   "yuv420p",
      //   // "-t",
      //   // "${imagePaths.length / 2}",
      //   outputFilePath
      // ]);

      // final command = ['-y'];
      // for (final path in imagePaths) {
      //   command.addAll(['-loop', '1', '-t', '1', '-i', path]);
      // }
      // command.addAll([ '-r', '$fps', '-vcodec', 'mpeg4', '-pix_fmt', 'yuv420p', '-shortest', outputFilePath]);

      // 运行 ffmpeg 命令
      // FFmpegSession ffmpegSession = await FFmpegKit.executeAsync(command);

      // // 拼接图片并输出视频
      // final arguments = [
      //   '-framerate',
      //   '30',
      //   '-i',
      //   imagePaths.join(' -i '),
      //   '-c:v',
      //   'libx264',
      //   '-profile:v',
      //   'high',
      //   '-pix_fmt',
      //   'yuv420p',
      //   '-crf',
      //   '23',
      //   '-preset',
      //   'ultrafast',
      //   outputFilePath
      // ];
      debugPrint("------${command.toString()}");
      FFmpegSession ffmpegSession =
          await FFmpegKit.executeWithArguments(command);

      ReturnCode? returnCode = await ffmpegSession.getReturnCode();
      // Return the output file path if FFmpeg succeeded
      if (!ReturnCode.isSuccess(returnCode)) {
        String? failStackTrace = await ffmpegSession.getFailStackTrace();
        throw Exception("FFmpeg Error: $returnCode - $failStackTrace");
      } else {
        debugPrint("成功了");
      }
    } on Exception catch (e) {
      debugPrint('$e');
      rethrow;
    } finally {
      FFmpegKitConfig.clearSessions();
      FFmpegKit.cancel();
    }
  }

  static Future<void> generateVideoFromImageDirPath(
      String imageDirPath, String outputFilePath,
      {int fps = 10}) async {
    try {
      // 设置 ffmpeg 环境变量和日志级别
      await FFmpegKitConfig.init();
      FFmpegKitConfig.enableLogCallback((log) {
        if (log.getLevel() == Level.avLogError) {
          debugPrint("ffmpeg 错误: ${log.getMessage()}");
          throw Exception("FFmpeg Error: ${log.getMessage()}");
        } else {
          debugPrint("ffmpeg log: ${log.getMessage()}");
        }
      });
      await FFmpegKitConfig.enableLogs();
      await FFmpegKitConfig.setLogLevel(Level.avLogVerbose);

      List<String> command = [];
      command.addAll(["-hide_banner", "-y"]);
      command.addAll([
        "-framerate",
        "$fps",
        '-i',
        "$imageDirPath/photo_%d.jpg",
        '-c:v',
        'mpeg4',
        '-pix_fmt',
        'yuv420p',
        '-crf',
        '16',
        '-preset',
        'ultrafast',
        outputFilePath
      ]);
      debugPrint("------${command.toString()}");
      FFmpegSession ffmpegSession =
          await FFmpegKit.executeWithArguments(command);

      ReturnCode? returnCode = await ffmpegSession.getReturnCode();
      // Return the output file path if FFmpeg succeeded
      if (!ReturnCode.isSuccess(returnCode)) {
        String? failStackTrace = await ffmpegSession.getFailStackTrace();
        throw Exception("FFmpeg Error: $returnCode - $failStackTrace");
      } else {
        debugPrint("成功了");
      }
    } on Exception catch (e) {
      debugPrint('$e');
      rethrow;
    } finally {
      FFmpegKitConfig.clearSessions();
      FFmpegKit.cancel();
    }
  }
}

class ImageDimensions {
  int width;
  int height;

  ImageDimensions(this.width, this.height);
}
