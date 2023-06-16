import 'dart:convert';
import 'package:e_book/models/book_model.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

List<BookModel> _books = [];

class ApiController {

  Future<List<BookModel>> getRecentBooks() async {

    String url = 'https://www.dbooks.org/api/recent';
    print("gaaaaaaaaaaado");
    final response = await http.get(Uri.parse(url));
    print("yes${response.statusCode}");
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());
        print(data.toString());
      for (Map i in data['books']) {
        _books.add(BookModel.fromJson(i));
      }
    } else {
      print("paaaaaaaaaaaado");
      Fluttertoast.showToast(msg: "Error Code: ${response.statusCode.toString()}");
    }
    return _books;
  }
}
