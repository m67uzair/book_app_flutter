import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:dio/dio.dart';
import 'package:e_book/controller/notifications_helper.dart';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List<BookModel> _books = [];
List<BookModel> _booksInQuery = [];
List<BookModel> _booksInCategory = [];
String? _searchQuery;
String? _catagory;

class ApiController extends ChangeNotifier {
  final Dio dio = Dio();
  final notificationsHelper = NotificationHelper();
  Map downloadProgressMap = {};

  final prefs;

  ApiController({required this.prefs});

  String? get searchQuery => _searchQuery;

  String? get category => _catagory;

  void setSearchQuery(String? query) {
    _catagory = null;
    _searchQuery = query;
    notifyListeners();
  }

  void setCategory(String? category) {
    _searchQuery = null;
    _catagory = category;
  }

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
    notifyListeners();
    return _books;
  }

  Future<List<BookModel>> getBooksByQuery() async {
    String url = 'https://www.dbooks.org/api/search/${_searchQuery ?? ""}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _booksInQuery.clear();
      final data = jsonDecode(response.body.toString());
      if (data['books'] != null) {
        for (Map i in data['books']) {
          _booksInQuery.add(BookModel.fromJson(i));
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
    }

    // notifyListeners();
    return _booksInQuery;
  }

  Future<List<BookModel>> getBooksByCategory() async {
    String url = 'https://www.dbooks.org/api/search/${_catagory ?? ""}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      _booksInCategory.clear();
      final data = jsonDecode(response.body.toString());
      if (data['books'] != null) {
        for (Map i in data['books']) {
          _booksInCategory.add(BookModel.fromJson(i));
        }
      }
    } else {
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
    }

    // notifyListeners();
    return _booksInCategory;
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
      print(downloadProgressMap.toString());
      final response = await dio.download(
        downloadURL,
        savePath,
        onReceiveProgress: (received, total) async {
          if (total != -1) {
            progress = (received / total * 100).toInt();
            totalSize = formatFileSize(total);
            downloadedSize = formatFileSize(received);

            print("pado+ ${downloadProgressMap[notificationId.toString()]}");
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

  int generateNotificationId(String bookId) {
    int truncatedId = int.tryParse(bookId) ?? 0;
    return truncatedId % (pow(2, 31) as int);
  }
}
