import 'package:e_book/views/home_screen.dart';
import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  final List<String> _screenStack = [HomeScreen.routeName];
  bool _isExpanded = true;

  List<String> get screenStack => _screenStack;

  bool get isExpanded => _isExpanded;

  void toggleIsExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void navigateToScreen(String routeName) {
    if (_screenStack.contains(routeName)) {
      _screenStack.remove(routeName);
    }
    _screenStack.add(routeName);
    notifyListeners();
  }

  bool navigateBack() {
    if (_screenStack.length > 1) {
      _screenStack.removeLast();
      notifyListeners();
    }
    return true;
  }
}
