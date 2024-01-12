import 'package:camera/camera.dart';
import 'package:chronicle_time/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'recording_controller.dart';

class RecordingPage extends StatelessWidget {
  RecordingPage({Key? key}) : super(key: key);

  final controller = Get.find<RecordingController>();

  @override
  Widget build(BuildContext context) {
    controller.recordData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('拍摄中'),
      ),
      body: RotatedBox(
        quarterTurns: controller.recordData.isLandscape ? 1 : 0,
        child: Obx(() {
          if (controller.isCameraInitialize.value) {
            return Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: controller.recordData.isLandscape
                        ? controller.cameraController!.value.aspectRatio
                        : 1 / controller.cameraController!.value.aspectRatio,
                    child: CameraPreview(controller.cameraController!),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Text(
                      '数量： ${controller.photoList.length}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    child: Text(
                      '时长： ${controller.timeElapsed.value}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color?>(
                                controller.isCamera.value
                                    ? Colors.red
                                    : Colors.blue),
                          ),
                          onPressed: controller.isCamera.value
                              ? controller.stopTaking
                              : controller.startTaking,
                          child: Icon(controller.isCamera.value
                              ? Icons.pause
                              : Icons.camera)
                          // Text(controller.isPlay.value ? "暂停" : "播放"),
                          ),
                    )),
              ],
            );
          } else {
            return Center(child: Obx(() => Text("${controller.message}")));
          }
        }),
      ),
    );
  }
}
