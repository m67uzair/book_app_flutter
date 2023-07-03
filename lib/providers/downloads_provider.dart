import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_book/controller/notifications_helper.dart';
import 'package:e_book/utilities/common_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class DownloadsProvider extends ChangeNotifier {
  final Dio dio = Dio();
  final notificationsHelper = NotificationHelper();

  final SharedPreferences prefs;
  Map downloadProgressMap = {};

  DownloadsProvider({required this.prefs});

  Map get downloadProgress => downloadProgressMap;

  loadDownloadProgress() {
    final downloadProgressJson = prefs.getString('downloadProgress');
    if (downloadProgressJson != null) {
      downloadProgressMap.addAll(jsonDecode(downloadProgressJson));
    }
  }

  Future<void> downloadBook(String downloadURL, int notificationId, String fileName, String image) async {
    final savePath = "/storage/emulated/0/Download/$fileName.pdf";

    if (fileAlreadyExits(savePath)) {
      Fluttertoast.showToast(msg: "File already exits");
      return;
    }

    int progress = 0;
    String totalSize = '0 MB';
    String downloadedSize = '0 MB';
    notificationId = generateNotificationId(notificationId.toString());

    try {
      downloadProgressMap[notificationId.toString()] = {
        'name': fileName,
        'progress': 0,
        'image': image,
        'downloadedSize': '0',
        'totalSize': '0'
      };
      notifyListeners();
      final response = await dio.download(
        downloadURL,
        savePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            progress = (received / total * 100).toInt();
            totalSize = formatFileSize(total);
            downloadedSize = formatFileSize(received);

            downloadProgressMap[notificationId.toString()]['progress'] = progress;
            downloadProgressMap[notificationId.toString()]['downloadedSize'] = downloadedSize;
            downloadProgressMap[notificationId.toString()]['totalSize'] = totalSize;

            notifyListeners();
            await notificationsHelper.showInProgressNotification(
                progress, totalSize, downloadedSize, notificationId, fileName);
          }
        },
        deleteOnError: true,
      );

      if (response.statusCode == 200) {
        await notificationsHelper.cancelInProgressNotification(notificationId);

        await notificationsHelper.showCompletedNotification(notificationId, fileName);

        downloadProgressMap[notificationId.toString()] = {
          'name': fileName,
          'progress': progress,
          'downloadedSize': downloadedSize,
          'totalSize': totalSize,
          'image': image,
        };

        prefs.setString('downloadProgress', jsonEncode(downloadProgressMap));
      } else {
        Fluttertoast.showToast(msg: "Error Downloading file");
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Error Downloading file");
    }
  }

  String formatFileSize(int size) {
    if (size <= 0) return '0 B';

    const int kb = 1024;
    const int mb = kb * 1024;
    const int gb = mb * 1024;

    late String unit;
    late double value;

    if (size >= gb) {
      unit = 'GB';
      value = (size / gb).toDouble();
    } else if (size >= mb) {
      unit = 'MB';
      value = (size / mb).toDouble();
    } else if (size >= kb) {
      unit = 'KB';
      value = (size / kb).toDouble();
    } else {
      unit = 'B';
      value = size.toDouble();
    }

    return '${value.toStringAsFixed(2)} $unit';
  }

  int generateNotificationId(String bookId) {
    int truncatedId = int.tryParse(bookId) ?? 0;
    return truncatedId % (pow(2, 31) as int);
  }
}
