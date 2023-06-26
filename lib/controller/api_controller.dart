import 'dart:convert';
import 'dart:io';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:e_book/controller/notifications_helper.dart';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List<BookModel> _books = [];
List<BookModel> _booksInQuery = [];

class ApiController extends ChangeNotifier {
  final Dio dio = Dio();
  final notificationsHelper = NotificationHelper();
  Map downloadProgressMap = {};

  Map get downloadProgress => downloadProgressMap;

  Future<List<BookModel>> getRecentBooks() async {
    String url = 'https://www.dbooks.org/api/recent';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
      for (Map i in data['books']) {
        _books.add(BookModel.fromJson(i));
      }
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
    }
    return _books;
  }

  Future<List<BookModel>> getBooksByQuery(String query) async {
    String url = 'https://www.dbooks.org/api/search/Code';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());

      for (Map i in data['books']) {
        _booksInQuery.add(BookModel.fromJson(i));
      }
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
    }
    return _booksInQuery;
  }

  Future<BookModel> getBookById(String id) async {
    String url = 'https://www.dbooks.org/api/book/$id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
      BookModel book = BookModel.fromJson(data);
      return book;
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
      return BookModel();
    }
  }

  Future<void> downloadBook(String downloadURL, int notificationId, String fileName, String image) async {
    final savePath = "/storage/emulated/0/Download/$fileName.pdf";

    if (fileAlreadyExits(savePath)) {
      Fluttertoast.showToast(msg: "File already exits");
      return;
    }

    try {
      downloadProgressMap[notificationId.toString()] = {
        'name': fileName,
        'progress': 0,
        'image': image,
        'downloadedSize': '0',
        'totalSize': '0'
      };
      notifyListeners();
      print(downloadProgressMap.toString());
      final response = await dio.download(
        downloadURL,
        savePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            final progress = (received / total * 100).toInt();
            final totalSize = formatFileSize(total);
            final downloadedSize = formatFileSize(received);

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
        print('cancel');
        await notificationsHelper.showCompletedNotification(notificationId, fileName);
        print('complete');
      } else {
        Fluttertoast.showToast(msg: "Error Downloading file");
      }
    } on Exception catch (e) {
      Fluttertoast.showToast(msg: "Error Downloading file");
    }
  }

  bool fileAlreadyExits(String filePath) {
    final file = File(filePath);
    if (file.existsSync()) {
      return true;
    } else {
      return false;
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
}
