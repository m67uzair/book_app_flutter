import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_contants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/models/book_model.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

class BookDetailsSheet extends StatelessWidget {
  const BookDetailsSheet(
      {super.key,
      required this.apiController,
      required this.bookId,
      required this.bookTitle,
      required this.bookSubtitle,
      required this.bookImageURL,
      required this.index});

  final ApiController apiController;
  final String bookId;
  final String bookTitle;
  final String bookSubtitle;
  final String bookImageURL;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: <Widget>[
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(38), topRight: Radius.circular(38)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.bookmark_outline),
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(Icons.share),
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(
                  width: 300,
                  child: Text(
                    bookTitle,
                    style: kSubTitleStyle.copyWith(color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 300,
                  child: Text(
                    bookSubtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                FutureBuilder(
                    future: apiController.getBookById(bookId),
                    builder: (context, AsyncSnapshot<BookModel> snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "DESCRIPTION",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data!.description!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  MetaDataField(
                                    title: "Pages",
                                    data: snapshot.data!.pages,
                                  ),
                                  const Spacer(),
                                  MetaDataField(
                                    title: "Year",
                                    data: snapshot.data!.year,
                                  ),
                                  const Spacer(),
                                  MetaDataField(
                                    title: "Publisher",
                                    data: snapshot.data!.publisher,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "AUTHORS:",
                                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.blueGrey),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    snapshot.data!.authors!,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 17,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton.icon(
                                    onPressed: () async {
                                      final url = Uri.parse("${snapshot.data!.url!}read/");

                                      try {
                                        print(url);
                                        if (await canLaunchUrl(url)) {
                                          await launchUrl(url);
                                        }
                                      } on Exception catch (e) {
                                        Fluttertoast.showToast(
                                            msg: "Cant Open link, read link might not  be "
                                                "available \n OR you don't have a stable internet connection",
                                            webShowClose: true,
                                            timeInSecForIosWeb: 5);
                                      }
                                    },
                                    icon: const Icon(Icons.chrome_reader_mode_outlined),
                                    label: const Text("Read Online"),
                                    style: const ButtonStyle(
                                        foregroundColor: MaterialStatePropertyAll(Colors.black),
                                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                                        elevation: MaterialStatePropertyAll(1)),
                                  ),
                                  TextButton.icon(
                                    onPressed: () async {
                                      await apiController.downloadBook(
                                          snapshot.data!.download!, index, snapshot.data!.title!);
                                    },
                                    icon: const Icon(Icons.download),
                                    label: const Text("Download Pdf"),
                                    style: const ButtonStyle(
                                        foregroundColor: MaterialStatePropertyAll(Colors.black),
                                        backgroundColor: MaterialStatePropertyAll(Colors.white),
                                        elevation: MaterialStatePropertyAll(1)),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    })
              ],
            ),
          ),
        ),
        Positioned(
          top: -90,
          child: Card(
            elevation: 10,
            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
            child: SizedBox(
              width: 100,
              height: 150,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  bookImageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MetaDataField extends StatelessWidget {
  final String? data;
  final String title;

  const MetaDataField({
    super.key,
    this.data,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500, color: Colors.blueGrey),
        ),
        AutoSizeText(
          data ?? "---",
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.bold),
        )
      ],
    );
  }
}
