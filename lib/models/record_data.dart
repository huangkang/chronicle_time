import 'package:flutter/material.dart';

class RecordData {
  int? id;
  late String recordName;
  late int recordInterval;

  //每秒的播放图片数
  late int recordFps;
  late int recordCreateTime;
  String? recordPhotoPath;
  String? recordVideoPath;
  bool isLandscape;

  RecordData(
      {this.id,
      required this.recordName,
      this.isLandscape = true,
      this.recordInterval = 5,
      this.recordFps = 10,
      required this.recordCreateTime,
      this.recordPhotoPath,
      this.recordVideoPath});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'recordName': recordName,
      'recordInterval': recordInterval,
      'recordFps': recordFps,
      'recordCreateTime': recordCreateTime,
      'recordPhotoPath': recordPhotoPath,
      'recordVideoPath': recordVideoPath
    };
  }

  static RecordData fromMap(Map<String, dynamic> map) {
    return RecordData(
        id: map['id'],
        recordName: map['recordName'],
        recordInterval: map['recordInterval'],
        recordFps: map['recordFps'],
        recordCreateTime: map['recordCreateTime'],
        recordPhotoPath: map['recordPhotoPath'],
        recordVideoPath: map['recordVideoPath']);
  }
}
