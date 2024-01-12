import 'package:get/get.dart';

import 'recording_controller.dart';

class RecordingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecordingController());
  }
}
