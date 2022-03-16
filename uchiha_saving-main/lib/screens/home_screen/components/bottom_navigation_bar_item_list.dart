import 'package:flutter/material.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:fluttericon/font_awesome_icons.dart';
import 'package:theme_provider/theme_provider.dart';

List<BottomNavigationBarItem> bottomNavigationBarList = [
  BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "Dashboard"),
  BottomNavigationBarItem(
      icon: Icon(FontAwesome5.money_bill), label: "Transactions"),
  BottomNavigationBarItem(icon: Icon(FontAwesome.book), label: "Articles"),
  BottomNavigationBarItem(icon: Icon(FontAwesome.dollar), label: "Saving"),
  BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
];

Color selectedColor(BuildContext context) {
  // return index == 0
  //     ? Colors.blue
  //     : index == 1
  //         ? Colors.red
  //         : index == 2
  //             ? Colors.green
  //             : Colors.purple;
  return ThemeProvider.controllerOf(context).currentThemeId == "dark"
      ? Colors.white
      : Colors.black;
}
