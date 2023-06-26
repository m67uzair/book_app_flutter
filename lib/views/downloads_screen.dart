import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_contants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_app_bar.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  List books = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageAppBar(title: "Downloads"),
          Consumer<ApiController>(builder: (context, apiController, child) {
            books = apiController.downloadProgress.entries.toList();
            return Expanded(
              child: books.isEmpty
                  ? const Center(
                      child: Text('Nothing to see here'),
                    )
                  : ListView.builder(
                      itemCount: books.length,
                      itemBuilder: (context, index) {
                        String title = books[index].value['name'] ?? "no title";
                        int progress = books[index].value['progress'];
                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 0,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 450,
                                child: LinearProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  value: progress.toDouble()/100,
                                ),
                              ),
                              AutoSizeText(title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16)),
                            ],
                          ),
                        );
                      },
                    ),
            );
          })
        ],
      ),
    );
  }
}
