import 'dart:convert';

import 'package:e_book/providers/auth_provider.dart';
import 'package:http/http.dart' as http;

class ApiController {
  Future<void> getBookShelves(String? accessToken) async {
    String apiKey = 'AIzaSyARMBgu4G9tunek3XrAPMW90QkA5yv5DwE';
    String url = 'https://www.googleapis.com/books/v1/volumes?q=*&maxResults=40&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body.toString());

      print(data);
    } else {
      print("pado");
    }
  }
}
