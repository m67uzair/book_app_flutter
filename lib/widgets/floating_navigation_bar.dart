import 'dart:math';

import 'package:e_book/views/books_screen.dart';
import 'package:e_book/views/downloads_screen.dart';
import 'package:e_book/views/home_screen.dart';
import 'package:e_book/views/saved_books_screen.dart';
import 'package:flutter/material.dart';

class FloatingNavigationBar extends StatefulWidget {
  final String currentRoute;

  const FloatingNavigationBar({Key? key, required this.currentRoute}) : super(key: key);

  @override
  State<FloatingNavigationBar> createState() => _FloatingNavigationBarState();
}

class _FloatingNavigationBarState extends State<FloatingNavigationBar> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final height = min(MediaQuery.of(context).size.height * 0.09, 60.0);
    final width =
        min(isExpanded ? MediaQuery.of(context).size.width * 0.6 : MediaQuery.of(context).size.width * 0.2, 200.0);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: height,
          width: isExpanded ? 150.0 : 0.0,
          curve: Curves.easeInOut,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            color: Colors.white,
            elevation: 4,
            child: Row(
              children: [
                Expanded(
                    child: NavbarButton(
                  icon: Icons.home,
                  route: HomeScreen.routeName,
                  currentRoute: widget.currentRoute,
                )),
                Expanded(
                    child: NavbarButton(
                  icon: Icons.bookmark,
                  route: SavedBooksScreen.routeName,
                  currentRoute: widget.currentRoute,
                )),
                Expanded(
                    child: NavbarButton(
                  icon: Icons.local_library_sharp,
                  route: BookScreen.routeName,
                  currentRoute: widget.currentRoute,
                )),
                Expanded(
                    child: NavbarButton(
                  icon: Icons.download,
                  route: DownloadsScreen.routeName,
                  currentRoute: widget.currentRoute,
                )),
              ],
            ),
          ),
        ),
        Material(
          elevation: 4,
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
          child: IconButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            style: ButtonStyle(
              shape: MaterialStatePropertyAll(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
              ),
            ),
            icon: isExpanded
                ? const Icon(
                    Icons.keyboard_arrow_right,
                  )
                : const Icon(Icons.keyboard_arrow_left),
          ),
        ),
      ],
    );
  }
}

class NavbarButton extends StatelessWidget {
  final IconData icon;

  final String route;
  final String currentRoute;

  NavbarButton({required this.icon, required this.route, required this.currentRoute});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      color: Color(0xff0DB067),
      onPressed: () {
        if (currentRoute == route) return;
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }
}
