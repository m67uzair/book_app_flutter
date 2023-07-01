import 'package:e_book/widgets/floating_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'books_screen.dart';
import 'downloads_screen.dart';
import 'home_screen.dart';
import 'saved_books_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> navigationWidgets = [
    const HomeScreen(),
    const BookScreen(),
    const SavedBooksScreen(),
    const DownloadsScreen(),
  ];

  static List<NavBarButton> navBarButtons = [
    NavBarButton(iconData: Icons.home, label: "Home"),
    NavBarButton(iconData: Icons.local_library_rounded, label: "Shop"),
    NavBarButton(iconData: Icons.bookmark, label: "My Cart"),
    NavBarButton(iconData: Icons.download, label: "Favorites"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingNavigationBar(
        navBarButtons: navBarButtons,
        currentIndex: _selectedIndex,
        onItemTapped: onItemTapped,
        selectedItemColor: Colors.red,
        unSelectedItemColor: const Color(0xFF9B9B9B),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: navigationWidgets,
      ),
    );
  }
}
