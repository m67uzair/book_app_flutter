import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/widgets/floating_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_app_bar.dart';

class DownloadsScreen extends StatefulWidget {
  static const routeName = '/downloads_screen';
  const DownloadsScreen({Key? key}) : super(key: key);

  @override
  State<DownloadsScreen> createState() => _DownloadsScreenState();
}

class _DownloadsScreenState extends State<DownloadsScreen> {
  late ApiController apiController;
  final ScrollController _scrollController = ScrollController();
  List books = [];

  @override
  void initState() {
    apiController = context.read<ApiController>();
    apiController.loadDownloadProgress();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTop());
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      floatingActionButton: const FloatingNavigationBar(currentRoute: DownloadsScreen.routeName),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,*/
      body: Column(
        children: [
          const ImageAppBar(title: "Downloads"),
          Consumer<ApiController>(builder: (context, downloadsProvider, child) {
            // scrollToTop();
            books = downloadsProvider.downloadProgress.entries.toList();
            return Expanded(
              child: books.isEmpty
                  ? const Center(
                      child: Text('Nothing to see here'),
                    )
                  : ListView.builder(
                      reverse: true,
                      itemCount: books.length,
                      controller: _scrollController,
                      itemBuilder: (context, index) {
                        String title = books[index].value['name'] ?? "no title";
                        int progress = books[index].value['progress'];
                        String downloadedSize = books[index].value['downloadedSize'];
                        String totalSize = books[index].value['totalSize'];
                        String image = books[index].value['image'];

                        return Card(
                          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                                      progress == 100
                                          ? Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(totalSize),
                                                  TextButton.icon(
                                                    onPressed: () {},
                                                    icon: const Icon(Icons.chrome_reader_mode_outlined),
                                                    label: const Text("Open"),
                                                    style: const ButtonStyle(
                                                        foregroundColor: MaterialStatePropertyAll(Colors.black),
                                                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                                                        elevation: MaterialStatePropertyAll(1)),
                                                  )
                                                ],
                                              ),
                                            )
                                          : AutoSizeText(
                                              "Downloading... $downloadedSize / $totalSize "
                                              "($progress%)",
                                              maxLines: 1,
                                            ),
                                      progress == 100
                                          ? const SizedBox.shrink()
                                          : LinearProgressIndicator(
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

  void scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500), // Adjust the duration as needed
        curve: Curves.easeInOut,
      );
    }
  }
}
