import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'waiting_controller.dart';

class WaitingPage extends StatelessWidget {
  WaitingPage({Key? key}) : super(key: key);

  final controller = Get.find<WaitingController>();

  @override
  Widget build(BuildContext context) {
    controller.recordData = Get.arguments;
    return Center(
      child: Obx(() => Text('${controller.message}')),
    );
  }
}
