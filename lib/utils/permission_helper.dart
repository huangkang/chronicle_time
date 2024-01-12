import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';

typedef VoidCallback = void Function();

class PermissionHelper {
  static VoidCallback defaultCall = () {};

  ///检查权限
  static void check(List<Permission> permissionList,
      {VoidCallback? onSuccess,
      VoidCallback? onFailed,
      bool isOpenSetting = true}) async {
    bool flag = true;
    for (var value in permissionList) {
      var status = await value.status;
      if (!status.isGranted) {
        flag = false;
        break;
      }
    }
    if (!flag) {
      PermissionStatus permissionStatus =
          await requestPermission(permissionList);
      debugPrint("$permissionList 权限：$permissionStatus");
      if (permissionStatus.isGranted) {
        onSuccess != null ? onSuccess() : defaultCall();
      } else if (permissionStatus.isDenied) {
        onFailed != null ? onFailed() : defaultCall();
        //iOS单独处理
        if (isOpenSetting) {
          openAppSettings();
        }
      } else if (permissionStatus.isPermanentlyDenied) {
        onFailed != null ? onFailed() : defaultCall();
        //iOS单独处理
        if (isOpenSetting) {
          openAppSettings();
        }
      } else if (permissionStatus.isRestricted) {
        onFailed != null ? onFailed() : defaultCall();
        //iOS单独处理
        if (isOpenSetting) {
          openAppSettings();
        }
      } else if (permissionStatus.isLimited) {
        onFailed != null ? onFailed() : defaultCall();
        //iOS单独处理
        if (isOpenSetting) {
          openAppSettings();
        }
      }
    } else {
      onSuccess != null ? onSuccess() : defaultCall();
    }
  }

  //申请权限
  static Future<PermissionStatus> requestPermission(
      List<Permission> permissionList) async {
    Map<Permission, PermissionStatus> statuses = await permissionList.request();
    PermissionStatus currentPermissionStatus = PermissionStatus.granted;
    statuses.forEach((key, value) {
      if (!value.isGranted) {
        currentPermissionStatus = value;
        return;
      }
    });
    return currentPermissionStatus;
  }
}
