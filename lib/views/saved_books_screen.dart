import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/constants/firebase_constants.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/providers/firebase_provider.dart';
import 'package:e_book/widgets/book_details_widgets.dart';
import 'package:e_book/widgets/floating_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_app_bar.dart';

class SavedBooksScreen extends StatefulWidget {
  static const routeName = '/saved_books_screen';

  const SavedBooksScreen({Key? key}) : super(key: key);

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  final ScrollController _scrollController = ScrollController();
  List books = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => scrollToTop());
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageAppBar(title: "Saved Books"),
          Consumer<SavedBooksProvider>(builder: (context, savedBooksProvider, child) {
            return Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: savedBooksProvider.getBooksInSaved(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.docs.isNotEmpty) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Text(
                              "${snapshot.data!.docs.length} Books are saved",
                              style: kSubTitleStyle,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              // reverse: true,
                              itemCount: snapshot.data!.docs.length,
                              padding: EdgeInsets.zero,
                              controller: _scrollController,
                              itemBuilder: (context, index) {
                                String bookId = snapshot.data!.docs[index].get(FirestoreConstants.bookId);
                                String bookName = snapshot.data!.docs[index].get(FirestoreConstants.bookName);
                                String bookImageURL = snapshot.data!.docs[index].get(FirestoreConstants.bookImageURL);
                                print('pado $bookId $bookName, $bookImageURL');

                                return InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (context) => Container(
                                        height: MediaQuery.of(context).size.height * 0.80,
                                        margin: const EdgeInsets.symmetric(horizontal: 10),
                                        child: BookDetailsSheet(
                                            bookId: bookId,
                                            bookTitle: bookName,
                                            bookSubtitle: "",
                                            bookImageURL: bookImageURL),
                                      ),
                                    );
                                  },
                                  child: Card(
                                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                    elevation: 4,
                                    color: Colors.white,
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.network(
                                            bookImageURL,
                                            height: 160,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            bookName,
                                            textAlign: TextAlign.start,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 100,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Consumer<SavedBooksProvider>(
                                                  builder: (context, savedBooksProvider, child) {
                                                return IconButton(
                                                  onPressed: () async {
                                                    await savedBooksProvider.removeBookFromSaved(bookId);
                                                  },
                                                  icon: const Icon(Icons.bookmark),
                                                );
                                              }),
                                              const Spacer(),
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.share),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      print('empty');
                      return const Center(child: Text("Nothing to see here"));
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 500), // Adjust the duration as needed
        curve: Curves.easeInOut,
      );
    }
  }
}
