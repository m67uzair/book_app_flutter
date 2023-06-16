import 'dart:convert';
import 'package:e_book/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List<BookModel> _books = [];
List<BookModel> _booksInQuery = [];

class ApiController {
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

  Future<List<BookModel>> getBookByQuery(String query) async {
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
}
