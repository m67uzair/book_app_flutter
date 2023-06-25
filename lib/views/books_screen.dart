import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_contants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/controller/notifications_helper.dart';
import 'package:e_book/models/book_model.dart';
import 'package:e_book/widgets/book_details_widgets.dart';
import 'package:e_book/widgets/image_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
NotificationHelper _notificationHelper = NotificationHelper();

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  ApiController apiController = ApiController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _notificationHelper.initialize();
  }

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
                                    child: BookDetailsSheet(
                                      apiController: apiController,
                                      bookId: books[index].id!,
                                      bookTitle: books[index].title!,
                                      bookSubtitle: books[index].subtitle ?? "",
                                      bookImageURL: books[index].image!,
                                      index: index,
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
