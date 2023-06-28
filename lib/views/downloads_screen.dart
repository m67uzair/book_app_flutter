import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_app_bar.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late ApiController apiController;
  List books = [];

  @override
  void initState() {
    apiController = context.read<ApiController>();
    apiController.loadDownloadProgress();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageAppBar(title: "Downloads"),
          Consumer<ApiController>(builder: (context, downloadsProvider, child) {
            books = downloadsProvider.downloadProgress.entries.toList();
            return Expanded(
              child: books.isEmpty
                  ? const Center(
                      child: Text('Nothing to see here'),
                    )
                  : ListView.builder(
                      itemCount: books.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        String title = books[index].value['name'] ?? "no title";
                        int progress = books[index].value['progress'];
                        String downloadedSize = books[index].value['downloadedSize'];
                        String totalSize = books[index].value['totalSize'];
                        String image = books[index].value['image'];

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10),
                          elevation: 4,
                          color: Colors.white,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.network(
                                  image,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      AutoSizeText(
                                        title,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      AutoSizeText(
                                        "Downloading... $downloadedSize / $totalSize ($progress%)",
                                        maxLines: 1,
                                      ),
                                      LinearProgressIndicator(
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.black),
                                        value: progress.toDouble() / 100,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
