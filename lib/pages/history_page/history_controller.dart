import 'dart:io';

import 'package:chronicle_time/models/record_data.dart';
import 'package:chronicle_time/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../utils/database_utils.dart';

class HistoryController extends GetxController {
  RxList<RecordData> recordList = RxList();
  final dbHelper = DatabaseHelper.instance;

  @override
  void onInit() {
    // TODO: implement onInit

    super.onInit();
  }

  @override
  // TODO: implement onDelete
  InternalFinalCallback<void> get onDelete => super.onDelete;

  @override
  void onReady() {
    // TODO: implement onReady
    getRecordFromDb();
    super.onReady();
  }

  Future<void> getRecordFromDb() async {
    List<Map<String, dynamic>> list =
        await dbHelper.queryAllRows(DatabaseHelper.recordTable);

    recordList.value =
        list.map((e) => RecordData.fromMap(e)).toList().reversed.toList();
  }

  void previewVideo(RecordData recordData) {
    if (recordData.recordVideoPath != null) {
      Get.toNamed(Routes.video, arguments: recordData);
    } else {
      Get.toNamed(Routes.waiting, arguments: recordData);
    }
  }

  void deleteVideo(RecordData recordData) async {
    //是否删除
    Get.defaultDialog(
        title: "提示",
        middleText: "确认是否删除？",
        confirm: ElevatedButton(
            onPressed: () async {
              Get.back();
              EasyLoading.show(status: "删除中～");
              //删除拍摄记录
              int count = await dbHelper.delete(
                  DatabaseHelper.recordTable, recordData.id!);
              if (count > 0) {
                if (recordData.recordPhotoPath != null) {
                  try {
                    //删除照片
                    await File(recordData.recordPhotoPath!)
                        .delete(recursive: true);
                  } catch (e) {
                    e.printError();
                  }
                }
                if (recordData.recordVideoPath != null) {
                  //删除文件
                  try {
                    await File(recordData.recordVideoPath!)
                        .delete(recursive: true);
                  } catch (e) {
                    e.printError();
                  }
                }
                final Directory extDir =
                    await getApplicationDocumentsDirectory();
                final String imageDir =
                    '${extDir.path}/Pictures/${recordData.id}';
                count = await dbHelper.deletePhoto(recordData.id!);
                if (count > 0) {
                  // 删除照片
                  try {
                    await Directory(imageDir).delete(recursive: true);
                  } catch (e) {
                    e.printError();
                  }
                }
                EasyLoading.dismiss();
                EasyLoading.showSuccess("删除成功");
                getRecordFromDb();
              } else {
                EasyLoading.showError("删除失败");
              }
            },
            child: const Text("确定")),
        cancel: ElevatedButton(
            onPressed: () {
              Get.back();
            },
            child: const Text("取消")));
  }
}
