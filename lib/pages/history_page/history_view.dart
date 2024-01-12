import 'package:chronicle_time/models/record_data.dart';
import 'package:chronicle_time/pages/history_page/record_tile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'history_controller.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage({Key? key}) : super(key: key);

  final controller = Get.find<HistoryController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('拍摄记录'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.recordList.isEmpty) {
        return const Center(child: Text('暂无记录'));
      } else {
        return ListView.builder(
          itemCount: controller.recordList.length,
          itemBuilder: (context, index) {
            return RecordTile(
              recordData: controller.recordList[index],
              onTap: () =>
                  controller.previewVideo(controller.recordList[index]),
              onDelete: () =>
                  controller.deleteVideo(controller.recordList[index]),
            );
          },
        );
      }
    });
  }
}

//
// void _startRecording(BuildContext context) async {
//   final int interval = await Helpers.showIntervalDialog(context);
//
//   if (interval != null) {
//     Navigator.of(context).push(MaterialPageRoute(
//       builder: (BuildContext context) => CameraPage(interval: interval),
//     )).then((value) => _getVideosFromDb());
//   }
// }
//
// Future<void> _getVideosFromDb() async {
//   final videos = await dbHelper.getVideos();
//   setState(() {
//     _videos = videos;
//   });
// }
