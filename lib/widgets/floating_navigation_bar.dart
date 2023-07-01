import 'dart:math';

import 'package:e_book/views/books_screen.dart';
import 'package:e_book/views/downloads_screen.dart';
import 'package:e_book/views/home_screen.dart';
import 'package:e_book/views/saved_books_screen.dart';
import 'package:flutter/material.dart';

class NavBarButton extends BottomNavigationBarItem {
  final IconData iconData;
  final String label;

  NavBarButton({
    required this.iconData,
    required this.label,
  }) : super(
          icon: Icon(iconData),
          label: label,
        );
}

class FloatingNavigationBar extends StatefulWidget {
  final List<NavBarButton> navBarButtons;
  final int currentIndex;
  final Function(int) onItemTapped;
  final Color selectedItemColor;
  final Color unSelectedItemColor;

  const FloatingNavigationBar({
    Key? key,
    required this.navBarButtons,
    required this.currentIndex,
    required this.onItemTapped,
    required this.selectedItemColor,
    required this.unSelectedItemColor,
  }) : super(key: key);

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
                for (var i = 0; i < widget.navBarButtons.length; i++)
                  Expanded(
                    child: IconButton(
                      icon: widget.navBarButtons[i].icon,
                      color: i == widget.currentIndex ? widget.selectedItemColor : widget.unSelectedItemColor,
                      onPressed: () {
                        widget.onItemTapped(i);
                      },
                    ),
                  ),
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
