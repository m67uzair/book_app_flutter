import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_constants.dart';
import 'package:e_book/controller/api_controller.dart';
import 'package:e_book/models/book_model.dart';
import 'package:e_book/widgets/image_app_bar.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List categoriesList = [
    {'title': 'Code', 'icon': SvgPicture.asset('assets/svgIcons/icons8-google-code.svg')},
    {'title': 'Art &\n Literature', 'icon': SvgPicture.asset('assets/svgIcons/icons8-poem.svg')},
    {'title': 'Biography /\nAutobiography', 'icon': SvgPicture.asset('assets/svgIcons/icons8-biography.svg')},
    {'title': 'Cooking', 'icon': SvgPicture.asset('assets/svgIcons/icons8-cooking.svg')},
    {'title': 'Drama', 'icon': SvgPicture.asset('assets/svgIcons/icons8-drama.svg')},
    {'title': 'Education', 'icon': SvgPicture.asset('assets/svgIcons/icons8-education.svg')},
    {'title': 'Fantasy', 'icon': SvgPicture.asset('assets/svgIcons/icons8-fantasy.svg')},
    {'title': 'Fiction', 'icon': SvgPicture.asset('assets/svgIcons/icons8-deadpool.svg')},
    {'title': 'History', 'icon': SvgPicture.asset('assets/svgIcons/icons8-greek-helmet.svg')},
  ];

  ApiController apiController = ApiController();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Column(
            children: [
              Stack(children: [
                Image.asset(
                  "assets/images/bookshelf.jpeg",
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  left: 5,
                  bottom: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      width: 140,
                      child: Text(
                        'book\njungle',
                        style: kTitleStyle,
                        maxLines: 2,
                      ),
                    ),
                  ),
                )
              ]),
              FutureBuilder(
                future: apiController.getRecentBooks(),
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
                        child: CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                                child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Text(
                                "Recents",
                                style: kTitleStyle.copyWith(color: Colors.black, fontSize: 25),
                              ),
                            )),
                            SliverToBoxAdapter(
                                child: SizedBox(
                              height: 240,
                              child: ListView.builder(
                                itemCount: books.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => books.isNotEmpty
                                    ? SizedBox(
                                        width: MediaQuery.of(context).size.width / 3,
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
                                              const SizedBox(height: 20),
                                              Text(books[index].title!,
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: kSubTitleStyle.copyWith(color: Colors.black, fontSize: 16))
                                            ],
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ),
                            )),
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Text(
                                  "Categories",
                                  style: kTitleStyle.copyWith(color: Colors.black, fontSize: 25),
                                ),
                              ),
                            ),
                            SliverGrid(
                              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                  maxCrossAxisExtent: MediaQuery.of(context).size.width / 3, mainAxisSpacing: 40),
                              delegate: SliverChildBuilderDelegate(
                                childCount: categoriesList.length,
                                (context, index) => Card(
                                  elevation: 12,
                                  margin: const EdgeInsets.all(10),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 48, width: 48, child: categoriesList[index]['icon']),
                                        const SizedBox(height: 10),
                                        Expanded(
                                          child: AutoSizeText(
                                            categoriesList[index]['title'],
                                            style: kSubTitleStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ));
  }
}
