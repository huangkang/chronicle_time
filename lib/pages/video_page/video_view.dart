import 'dart:io';

import 'package:esys_flutter_share_plus/esys_flutter_share_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import '../../utils/date_utils.dart';
import 'video_controller.dart';

class VideoPage extends StatelessWidget {
  VideoPage({Key? key}) : super(key: key);

  final controller = Get.find<VideoController>();

  @override
  Widget build(BuildContext context) {
    controller.recordData = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('视频详情'),
        actions: [
          IconButton(
              onPressed: () async {
                EasyLoading.show(status: '加载中...');
                final file = File(controller.recordData.recordVideoPath!);
                await Share.file(
                  '分享视频',
                  '${controller.recordData.recordName}.mp4',
                  file.readAsBytesSync(),
                  'video/*',
                );
                EasyLoading.dismiss();
              },
              icon: const Icon(Icons.share))
        ],
      ),
      body: Obx(
        () {
          if (controller.isVideoPlayerInitialize.value) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio:
                        controller.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(controller.videoPlayerController),
                  ),
                ),
                // VideoPlayer(controller.videoPlayerController),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    height: 70,
                    color: Colors.black12,
                    child: Stack(
                      children: [
                        Positioned(
                            left: 16.0,
                            right: 100,
                            child: Column(
                              children: [
                                Slider(
                                  value: controller
                                      .currentPosition.value.inSeconds
                                      .toDouble(),
                                  max: controller.duration.value.inSeconds
                                      .toDouble(),
                                  onChanged: controller.seekTo,
                                ),
                                Text(
                                  "${FormatDateUtils.formatDuration(controller.currentPosition.value)} / ${FormatDateUtils.formatDuration(controller.duration.value)}",
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            )),
                        Positioned(
                          right: 16,
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            child: ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color?>(
                                          controller.isPlay.value
                                              ? Colors.red
                                              : Colors.blue),
                                ),
                                onPressed: controller.play,
                                child: Icon(controller.isPlay.value
                                    ? Icons.pause
                                    : Icons.play_arrow)
                                // Text(controller.isPlay.value ? "暂停" : "播放"),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          } else {
            return Center(child: Obx(() => Text("${controller.message}")));
          }
        },
      ),
    );
  }
}
