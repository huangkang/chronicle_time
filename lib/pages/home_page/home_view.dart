import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'home_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('时光鸡'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Center(
      child: SizedBox(
        height: 210,
        child: Column(
          children: [
            SizedBox(
              height: 100,
              width: 200,
              child: ElevatedButton(
                onPressed: controller.showRecordingSettings,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.videocam,
                      size: 30,
                    ),
                    Text("拍摄")
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 100,
              width: 200,
              child: ElevatedButton(
                onPressed: controller.pushHistory,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green[300]),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.history,
                      size: 30,
                    ),
                    Text("记录")
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
