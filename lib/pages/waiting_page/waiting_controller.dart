import 'dart:io';

import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/record_data.dart';
import '../../routes/app_routes.dart';
import '../../services/ffmpeg_service.dart';
import '../../utils/database_utils.dart';

class WaitingController extends GetxController {
  final dbHelper = DatabaseHelper.instance;
  late RecordData recordData;
  Rx<String> message = '视频生成中~'.obs;

  @override
  Future<void> onReady() async {
    // TODO: implement onReady
    // List<Map<String, dynamic>> list = await dbHelper.queryRows(
    //     DatabaseHelper.photoTable, DatabaseHelper.recordId, recordData.id!);
    // List<String> photoPathList =
    //     list.map((e) => e[DatabaseHelper.photoPath] as String).toList();
    // 获取应用程序文档目录
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Videos';
    await Directory(dirPath).create(recursive: true);
    // 生成一个新的唯一文件名
    final String filePath =
        '$dirPath/${recordData.id}_${DateTime.now().millisecondsSinceEpoch}.mp4';

    final String imageDir = '${extDir.path}/Pictures/${recordData.id}';

    try {
      await FFmpegService.generateVideoFromImageDirPath(imageDir, filePath,
          fps: recordData.recordFps);
      // await FFmpegService.generateVideoFromImages(photoPathList, filePath);
      //保存视频
      message.value = "保存数据中~";
      int count = await dbHelper.update(DatabaseHelper.recordTable,
          {"id": recordData.id, DatabaseHelper.recordVideoPath: filePath});
      if (count > 0) {
        recordData.recordVideoPath = filePath;
      }
      //删除历史数据
      message.value = "清理缓存中~";
      count = await dbHelper.deletePhoto(recordData.id!);
      if (count > 0) {
        //删除成功 删除照片
        try {
          await Directory(imageDir).delete(recursive: true);
        } catch (e) {
          e.printError();
        }
      }
      message.value = "即将跳转~";

      await Future.delayed(const Duration(seconds: 1));
      //跳转到生成视频的页
      Get.offAndToNamed(Routes.video, arguments: recordData);
    } on Exception catch (e) {
      //拼接失败
      message.value = '视频生成失败：${e.toString()}';
    }

    super.onReady();
  }
}
