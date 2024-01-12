import 'package:chronicle_time/models/record_data.dart';
import 'package:chronicle_time/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../utils/database_utils.dart';

class RecordingSettingsController extends GetxController {
  final dbHelper = DatabaseHelper.instance;

  // 姓名
  var name = ''.obs;

  // 间隔时间，初始值为1秒
  var isLandscape = true.obs;

  // 间隔时间，初始值为1秒
  var interval = 1.obs;

  // 帧数，默认为每秒5张
  var fps = 5.obs;

  // 更新姓名
  void updateName(String value) {
    name.value = value;
  }

  // 更新帧数
  void updateLandscape(bool? value) {
    if (value != null) {
      isLandscape.value = value;
    }
  }

  // 更新间隔时间
  void updateInterval(int? value) {
    if (value != null) {
      interval.value = value;
    }
  }

  // 更新帧数
  void updateFps(int? value) {
    if (value != null) {
      fps.value = value;
    }
  }

  // 关闭弹窗
  void closePopup() {
    Get.back();
  }

  // @override
  // void onClose() {
  //   // TODO: implement onClose
  //   debugPrint("---------");
  //   name.value = '';
  //   interval.value = 5;
  //   super.onClose();
  // }

  // 保存设置
  Future<void> saveSettings() async {
    // TODO: 保存设置到本地或服务器
    if (name.value.isEmpty) {
      EasyLoading.showError("名字不能为空");
      return;
    }
    RecordData recordData = RecordData(
        recordName: name.value,
        isLandscape: isLandscape.value,
        recordInterval: interval.value,
        recordFps: fps.value,
        recordCreateTime: DateTime.now().millisecondsSinceEpoch);
    // int id =
    //     await dbHelper.insert(DatabaseHelper.recordTable, recordData.toMap());
    // if (id > 0) {
      // recordData.id = id;
      Get.offAndToNamed(Routes.recording, arguments: recordData);
    // } else {
    //   EasyLoading.showError("保存数据失败");
    // }
  }
}
