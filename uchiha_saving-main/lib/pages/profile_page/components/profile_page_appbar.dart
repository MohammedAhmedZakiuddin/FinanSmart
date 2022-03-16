import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/api/auth.dart';
import 'package:uchiha_saving/models/person.dart';

class ProfilePageAppBar extends StatelessWidget {
  final Person person;
  const ProfilePageAppBar({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text(
                "Are you sure?",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(),
              ),
              content: Text(
                "Do you want to logout?",
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Auth().signOut().then((value) {
                      Navigator.of(ctx).pop();
                    });
                  },
                  icon: Icon(
                    Icons.check_box,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  icon: Icon(
                    Icons.cancel_rounded,
                  ),
                ),
              ],
            ),
          );
        },
        icon: Icon(Icons.logout),
      ),
      actions: [
        IconButton(
          onPressed: () {
            ThemeProvider.controllerOf(context).nextTheme();
          },
          icon: Icon(CupertinoIcons.moon_stars),
        )
      ],
      foregroundColor:
          ThemeProvider.controllerOf(context).currentThemeId == "dark"
              ? Colors.white
              : Colors.black,
      backgroundColor: Colors.transparent,
    );
  }
}
