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
            future: apiController.getBookByQuery("arts"),
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
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                    topLeft: Radius.circular(20),
                                  )),
                                  builder: (context) => Container(
                                    // color: const Color(0xFF737373).withOpacity(0),
                                    height: MediaQuery.of(context).size.height * 0.80,
                                    child: Stack(
                                      clipBehavior: Clip.none,
                                      alignment: Alignment.center,
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.80,
                                          width: double.infinity,
                                          margin: const EdgeInsets.symmetric(horizontal: 10),
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(32), topRight: Radius.circular(32)),
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
