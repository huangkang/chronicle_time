import 'dart:io';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../../models/record_data.dart';

class VideoController extends GetxController {
  late RecordData recordData;
  late VideoPlayerController videoPlayerController;
  var isVideoPlayerInitialize = false.obs;
  Rx<String> message = "播放器初始化中...".obs;

  late Rx<bool> isPlay = false.obs;
  late Rx<Duration> duration = const Duration().obs;
  Rx<Duration> currentPosition = const Duration().obs;

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    videoPlayerController =
        VideoPlayerController.file(File(recordData.recordVideoPath!));

    videoPlayerController
      ..initialize().then((value) {
        isVideoPlayerInitialize.value = true;
        duration.value = videoPlayerController.value.duration;
      })
      ..addListener(() {
        if (videoPlayerController.value.isPlaying != isPlay.value) {
          isPlay.value = videoPlayerController.value.isPlaying;
        }
        currentPosition.value = videoPlayerController.value.position;
      })
      ..setLooping(true);
    super.onReady();
  }

  void play() {
    if (videoPlayerController.value.isPlaying) {
      videoPlayerController.pause();
    } else {
      videoPlayerController.play();
    }
  }

  void seekTo(double value) {
    videoPlayerController.seekTo(Duration(seconds: value.toInt()));
  }

  @override
  void onClose() {
    // TODO: implement onClose
    videoPlayerController.dispose();
    super.onClose();
  }
}
