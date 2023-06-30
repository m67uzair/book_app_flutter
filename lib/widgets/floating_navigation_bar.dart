import 'dart:math';

import 'package:flutter/material.dart';

class FloatingNavigationBar extends StatefulWidget {
  const FloatingNavigationBar({Key? key}) : super(key: key);

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
                Expanded(child: NavbarButton(Icons.home)),
                Expanded(child: NavbarButton(Icons.bookmark)),
                Expanded(child: NavbarButton(Icons.search)),
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

/*  final String route;
  final String currentRoute;*/

  NavbarButton(
    this.icon,
    // this.route, this.currentRoute
  );

  @override
  Widget build(BuildContext context) {
    // final books = Provider.of<Books>(context, listen: false);
    return IconButton(
      icon: Icon(icon),
      color: Color(0xff0DB067),
      onPressed: () {
        // if (currentRoute == route) return;
        // Navigator.of(context).pushReplacementNamed(route);
        // books.setFirstLoad(true);
      },
    );
  }
}
