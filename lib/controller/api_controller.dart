import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:e_book/controller/notifications_helper.dart';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

List<BookModel> _books = [];
List<BookModel> _booksInQuery = [];

class ApiController {
  final Dio dio = Dio();
  final notificationsHelper = NotificationHelper();

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

  Future<void> downloadBook(String downloadURL, int index) async {
    final response = await dio.download(
      downloadURL,
      "/storage/emulated/0/Download/test.pdf",
      onReceiveProgress: (received, total) async{
        if (total != -1) {
          await notificationsHelper.showInProgressNotification((received / total * 100).toInt(), 0);
          print("${(received / total * 100).toStringAsFixed(0)}%");
        }
      },
    );
  }
}
