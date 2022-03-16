import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';

class ArticlesPageAppBar extends StatelessWidget {
  final Person person;
  const ArticlesPageAppBar({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      title: Text(
        "Articles",
        style: GoogleFonts.lato(),
      ),
      foregroundColor:
          ThemeProvider.controllerOf(context).currentThemeId == "dark"
              ? Colors.white
              : Colors.black,
      backgroundColor: Colors.transparent,
      pinned: true,
    );
  }
}
