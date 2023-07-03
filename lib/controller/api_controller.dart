import 'dart:convert';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:open_file_plus/open_file_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utilities/common_functions.dart';

List<BookModel> _books = [];
List<BookModel> _booksInQuery = [];
List<BookModel> _booksInCategory = [];
String? _searchQuery;
String? _catagory;

class ApiController extends ChangeNotifier {

  ApiController();

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



}
