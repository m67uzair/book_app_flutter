import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_book/constants/firebase_constants.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:e_book/providers/firebase_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/image_app_bar.dart';

class SavedBooksScreen extends StatefulWidget {
  const SavedBooksScreen({Key? key}) : super(key: key);

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  late SavedBooksProvider savedBooksProvider;
  final ScrollController _scrollController = ScrollController();
  List books = [];

  @override
  void initState() {
    savedBooksProvider = Provider.of<SavedBooksProvider>(context, listen: false);
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
      body: Column(
        children: [
          const ImageAppBar(title: "Downloads"),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: savedBooksProvider.getBooksInSaved(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.isNotEmpty) {
                  print('not emppty');
                  return ListView.builder(
                    // reverse: true,
                    itemCount: snapshot.data!.docs.length,
                    controller: _scrollController,
                    itemBuilder: (context, index) {
                      String bookId = snapshot.data!.docs[index].get(FirestoreConstants.bookId);
                      String bookName = snapshot.data!.docs[index].get(FirestoreConstants.bookName);
                      String bookImageURL = snapshot.data!.docs[index].get(FirestoreConstants.bookImageURL);
                      print('pado $bookId $bookName, $bookImageURL');

                      return Card(
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
                            AutoSizeText(
                              bookName,
                              textAlign: TextAlign.start,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16),
                            ),
                            SizedBox(
                              height: 100,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Consumer<SavedBooksProvider>(builder: (context, savedBooksProvider, child) {
                                    return IconButton(
                                      onPressed: () async {
                                        if (!savedBooksProvider.isBookSaved) {
                                          await savedBooksProvider.addBookToSaved(
                                              bookId: bookId, bookName: bookName, bookImageURL: bookImageURL);
                                        } else {
                                          await savedBooksProvider.removeBookFromSaved(bookId);
                                        }
                                      },
                                      icon: Icon(
                                          savedBooksProvider.isBookSaved ? Icons.bookmark : Icons.bookmark_outline),
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
                      );
                    },
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
          ))
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
