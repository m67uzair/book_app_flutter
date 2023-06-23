import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_contants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/models/book_model.dart';
import 'package:e_book/widgets/image_app_bar.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  ApiController apiController = ApiController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const ImageAppBar(title: "Art & Entertainment"),
          FutureBuilder(
            future: apiController.getBooksByQuery("arts"),
            builder: (BuildContext context, AsyncSnapshot<List<BookModel>> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Expanded(
                  child: AlertDialog(
                    elevation: 0,
                    content: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                );
              } else {
                List<BookModel> books = snapshot.data ?? [];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      itemCount: books.length,
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: MediaQuery.of(context).size.width / 3,
                        mainAxisSpacing: 20,
                        childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height),
                      ),
                      itemBuilder: (context, index) => books.isNotEmpty
                          ? InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => Container(
                                    height: MediaQuery.of(context).size.height * 0.80,
                                    margin: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(38), topRight: Radius.circular(38)),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                            child: Column(
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
                                                Text(
                                                  books[index].title!,
                                                  style: kSubTitleStyle.copyWith(color: Colors.black),
                                                  textAlign: TextAlign.center,
                                                ),
                                                Text(
                                                  books[index].subtitle ?? "",
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 20,
                                                ),
                                                FutureBuilder(
                                                    future: apiController.getBookById(books[index].id!),
                                                    builder: (context, AsyncSnapshot<BookModel> snapshot) {
                                                      if (snapshot.hasData) {
                                                        return Expanded(
                                                            child: Column(
                                                          children: [
                                                            Container(
                                                              decoration: BoxDecoration(
                                                                  color: Colors.blueAccent.withOpacity(0.1),
                                                                  borderRadius: BorderRadius.circular(8)),
                                                              padding: const EdgeInsets.symmetric(
                                                                  horizontal: 10, vertical: 10),
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  const Text(
                                                                    "DESCRIPTION",
                                                                    style: TextStyle(
                                                                        fontSize: 17,
                                                                        fontWeight: FontWeight.w500,
                                                                        color: Colors.blueGrey),
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
                                                            )
                                                          ],
                                                        ));
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
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(8))),
                                            child: Container(
                                              width: 100,
                                              height: 150,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(8),
                                                child: Image.network(
                                                  books[index].image!,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                elevation: 0,
                                color: Colors.transparent,
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Image.network(
                                          books[index].image.toString(),
                                          height: 160,
                                          fit: BoxFit.cover,
                                        )),
                                    const SizedBox(height: 10),
                                    AutoSizeText(books[index].title!,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16))
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
