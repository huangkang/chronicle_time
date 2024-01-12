import 'dart:async';
import 'dart:io';

import 'package:chronicle_time/models/photo_data.dart';
import 'package:chronicle_time/models/record_data.dart';
import 'package:chronicle_time/routes/app_routes.dart';
import 'package:chronicle_time/utils/permission_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wakelock/wakelock.dart';

import '../../utils/database_utils.dart';
import '../../utils/date_utils.dart';

class RecordingController extends GetxController {
  final dbHelper = DatabaseHelper.instance;
  var isCameraInitialize = false.obs;
  Rx<String> message = "相机初始化中...".obs;

  CameraController? cameraController;

  // Future<void>? initializeControllerFuture;
  Timer? timer;

  RxList<PhotoData> photoList = RxList();

  Stopwatch stopwatch = Stopwatch();
  Rx<String> timeElapsed = '00:00:00'.obs;

  late RecordData recordData;

  Rx<bool> isCamera = false.obs;

  int index = 1;

  @override
  void onReady() {
    // TODO: implement onReady
    // if(recordData.isLandscape){
    //   // 强制横屏
    //   WidgetsFlutterBinding.ensureInitialized();
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.landscapeRight
    //   ]);
    // }
    Wakelock.enable();
    requestCameraPermission();
    super.onReady();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> requestCameraPermission() async {
    PermissionHelper.check([Permission.camera], onSuccess: () async {
      List<CameraDescription> cameras = await availableCameras();
      // 初始化相机控制器
      cameraController = CameraController(
        // 获取第一个可用的后置摄像头
        cameras[0],
        ResolutionPreset.max,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      // If the controller is updated then update the UI.
      cameraController!.addListener(() {
        if (cameraController!.value.hasError) {
          message.value = '相机初始化错误：${cameraController!.value.errorDescription}';
        }
      });

      try {
        // 异步初始化相机控制器
        await cameraController!.initialize();
        if (recordData.isLandscape) {
          await cameraController!
              .lockCaptureOrientation(DeviceOrientation.landscapeRight);
        } else {
          await cameraController!
              .lockCaptureOrientation(DeviceOrientation.portraitUp);
        }
        await cameraController!.setFlashMode(FlashMode.auto);
      } on CameraException catch (e) {
        switch (e.code) {
          case 'CameraAccessDenied':
            message.value = '您已拒绝相机访问。';
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            // iOS only
            message.value = '请在设置中启用相机访问。';
            break;
          case 'CameraAccessRestricted':
            // iOS only
            message.value = '相机访问受到限制。';
            break;
          case 'AudioAccessDenied':
            message.value = '您已拒绝音频访问。';
            break;
          case 'AudioAccessDeniedWithoutPrompt':
            // iOS only
            message.value = '请在设置中启用音频访问。';
            break;
          case 'AudioAccessRestricted':
            // iOS only
            message.value = '音频访问受到限制。';
            break;
          default:
            message.value = e.toString();
            break;
        }
      }
      isCameraInitialize.value = true;
      message.value = '初始化完成';
    }, onFailed: () {
      message.value = "暂无权限";
    });
  }

  Future<void> _handleTake() async {
    if (cameraController!.value.isInitialized) {
      final path = await _takePhoto();
      if (path.isNotEmpty) {
        PhotoData photoData = PhotoData(
            recordId: recordData.id!,
            photoTime: DateTime.now().millisecondsSinceEpoch,
            photoPath: path);
        int photoId =
            await dbHelper.insert(DatabaseHelper.photoTable, photoData.toMap());
        if (photoId > 0) {
          photoData.id = photoId;
          photoList.add(photoData);
        }
      }
    }
  }

  @override
  void onClose() {
    // TODO: implement onClose
    Wakelock.disable();
    timer?.cancel();
    cameraController?.dispose();
    // if(recordData.isLandscape) {
    //   // 解除横屏
    //   WidgetsFlutterBinding.ensureInitialized();
    //   SystemChrome.setPreferredOrientations([
    //     DeviceOrientation.portraitUp,
    //     DeviceOrientation.landscapeRight,
    //     DeviceOrientation.landscapeLeft
    //   ]);
    // }
    super.onClose();
  }

  Future<String> _takePhoto() async {
    // 获取应用程序文档目录
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/${recordData.id}';
    await Directory(dirPath).create(recursive: true);
    // 生成一个新的唯一文件名
    final String filePath = '$dirPath/photo_${index++}.jpg';
    try {
      // 拍照
      XFile pictureFile = await cameraController!.takePicture();
      // 将拍摄的照片保存到指定的路径
      await pictureFile.saveTo(filePath);
      saveThumbnail(filePath);
    } on CameraException catch (e) {
      debugPrint("拍照失败：${e.toString()}");
      index--;
      //拍照失败
      return "";
    } on UnimplementedError catch (e) {
      debugPrint("文件保存失败：${e.toString()}");
      index--;
      return "";
    }
    debugPrint(filePath);
    return filePath;
  }

  saveThumbnail(String filePath) async {
    if (recordData.recordPhotoPath == null) {
      //保存图片
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Thumbnails';
      await Directory(dirPath).create(recursive: true);
      // 生成一个新的唯一文件名
      final String thumbnailFilePath = '$dirPath/photo_${recordData.id}.jpg';
      try {
        var result = await FlutterImageCompress.compressAndGetFile(
          filePath,
          thumbnailFilePath,
          minWidth: 200,
          minHeight: 200,
          quality: 88,
        );

        if (result != null) {
          int count = await dbHelper.update(DatabaseHelper.recordTable, {
            "id": recordData.id,
            DatabaseHelper.recordPhotoPath: thumbnailFilePath
          });
          if (count > 0) {
            recordData.recordPhotoPath = thumbnailFilePath;
          }
        }
      } catch (e) {
        e.printError();
      }
    }
  }

  Future<void> startTaking() async {
    int id =
        await dbHelper.insert(DatabaseHelper.recordTable, recordData.toMap());
    if (id > 0) {
      recordData.id = id;

      isCamera.value = true;
      // await cameraController!
      //     .lockCaptureOrientation(DeviceOrientation.portraitUp);
      //拍摄第一张
      _handleTake();
      int index = 0;
      // 启动定时器，每隔一段时间拍摄一张照片
      timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
        index++;
        timeElapsed.value = FormatDateUtils.formatDuration(stopwatch.elapsed);
        if (index >= recordData.recordInterval) {
          index = 0;
          _handleTake();
        }
      });
      stopwatch.start();
    } else {
      EasyLoading.showError("保存数据失败");
    }
  }

  void stopTaking() {
    isCamera.value = false;
    timer?.cancel();
    stopwatch.stop();
    //跳转到生成视频的页
    Get.offAndToNamed(Routes.waiting, arguments: recordData);
  }
}
