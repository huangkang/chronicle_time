import 'dart:io';

import 'package:chronicle_time/utils/date_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/record_data.dart';

typedef OnTap = void Function();
typedef OnDelete = void Function();

class RecordTile extends StatelessWidget {
  final OnTap? onTap;
  final OnDelete? onDelete;
  final RecordData recordData;

  const RecordTile(
      {required this.recordData, super.key, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
                border: Border.all(
                  color: Colors.black12,
                  width: 1.0,
                ),
              ),
              child: recordData.recordPhotoPath == null
                  ? const Icon(
                      Icons.image_outlined,
                      size: 80,
                    )
                  : Image.file(
                      File(recordData.recordPhotoPath!),
                      width: 80,
                      height: 80,
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      recordData.recordName,
                      style: Get.textTheme.titleLarge,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      FormatDateUtils.formatDateTime(
                          DateTime.fromMillisecondsSinceEpoch(
                              recordData.recordCreateTime)),
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(color: Colors.black45),
                    )
                  ],
                ),
              ),
            ),
            IconButton(
                onPressed: onDelete,
                icon: const Icon(
                  Icons.delete_forever_outlined,
                  color: Colors.red,
                ))
          ],
        ),
      ),
    );
  }
}
