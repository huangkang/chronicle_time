import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'recording_settings_controller.dart';

class RecordingSettingsView extends StatefulWidget {
  RecordingSettingsView({Key? key}) : super(key: key);

  @override
  State<RecordingSettingsView> createState() => _RecordingSettingsState();
}

class _RecordingSettingsState extends State<RecordingSettingsView> {
  final controller = Get.put(RecordingSettingsController());

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('设置拍摄信息'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              onChanged: controller.updateName,
              decoration: const InputDecoration(
                labelText: '作品名字',
              ),
            ),
            Obx(() => Row(
                  children: [
                    const Text('横屏拍摄：'),
                    const SizedBox(width: 10),
                    DropdownButton<bool>(
                      value: controller.isLandscape.value,
                      items: [true, false]
                          .map((value) => DropdownMenuItem<bool>(
                                value: value,
                                child: Text(value ? "是" : "否"),
                              ))
                          .toList(),
                      onChanged: controller.updateLandscape,
                    ),
                  ],
                )),
            Obx(() => Row(
                  children: [
                    const Text('拍照间隔时间（秒）：'),
                    const SizedBox(width: 10),
                    DropdownButton<int>(
                      value: controller.interval.value,
                      items: [1, 3, 5, 10, 15, 30, 60]
                          .map((value) => DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              ))
                          .toList(),
                      onChanged: controller.updateInterval,
                    ),
                  ],
                )),
            Obx(
              () => Row(
                children: [
                  const Text('生成视频帧数：'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: controller.fps.value,
                    items: [1, 3, 5, 10, 15, 30, 60]
                        .map((value) => DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            ))
                        .toList(),
                    onChanged: controller.updateFps,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: controller.closePopup,
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: controller.saveSettings,
          child: const Text('保存'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<RecordingSettingsController>();
    super.dispose();
  }
}
