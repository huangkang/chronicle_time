import 'package:chronicle_time/routes/app_routes.dart';
import 'package:get/get.dart';

import '../recording_settings_view/recording_settings_view.dart';

class HomeController extends GetxController {
  void showRecordingSettings() async {
    Get.dialog(RecordingSettingsView());
  }

  void pushHistory() async {
    Get.toNamed(Routes.history);
  }
}
