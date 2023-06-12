import 'package:auto_size_text/auto_size_text.dart';
import 'package:e_book/constants/style_contants.dart';
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
    {'title': 'Art & Literature', 'icon': SvgPicture.asset('assets/svgIcons/icons8-poem.svg')},
    {'title': 'Biography / Autobiography', 'icon': SvgPicture.asset('assets/svgIcons/icons8-biography.svg')},
    {'title': 'Cooking', 'icon': SvgPicture.asset('assets/svgIcons/icons8-cooking.svg')},
    {'title': 'Drama', 'icon': SvgPicture.asset('assets/svgIcons/icons8-drama.svg')},
    {'title': 'Education', 'icon': SvgPicture.asset('assets/svgIcons/icons8-education.svg')},
    {'title': 'Fantasy', 'icon': SvgPicture.asset('assets/svgIcons/icons8-fantasy.svg')},
    {'title': 'Fiction', 'icon': SvgPicture.asset('assets/svgIcons/icons8-deadpool.svg')},
    {'title': 'History', 'icon': SvgPicture.asset('assets/svgIcons/icons8-greek-helmet.svg')},
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
        value: const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
        child: Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        "book jungle",
                        style: kTitleStyle,
                        maxLines: 2,
                      ),
                    ),
                  ),
                )
              ]),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                child: Text(
                  "Categories",
                  style: kTitleStyle.copyWith(color: Colors.black, fontSize: 25),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: categoriesList.length,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: MediaQuery.of(context).size.width/3 , mainAxisSpacing: 40),
                  itemBuilder: (context, index) => Card(
                    elevation: 12,
                    margin: const EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: LayoutBuilder(builder: (context, constraints) {
                      return Padding(
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
                                maxLines: 2,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}
