import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/tools/custom_navigator.dart';
import 'package:uchiha_saving/tools/get_random_color.dart';
import 'package:uchiha_saving/uis/notifications_ui/notifications_ui.dart';

class DashboardAppBar extends StatelessWidget {
  final Person person;
  const DashboardAppBar({Key? key, required this.person}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return SliverAppBar(
      pinned: true,
      stretch: true,
      backgroundColor: Colors.transparent,
      foregroundColor:
          ThemeProvider.controllerOf(context).currentThemeId == "dark"
              ? Colors.white
              : Colors.black,
      // leading: FlareActor(
      //   "assets/animations/Dragon.flr",
      //   animation: "Untitled",
      //   color: ThemeProvider.controllerOf(context).currentThemeId == "dark"
      //       ? Colors.white
      //       : Colors.black,
      // ),
      actions: [
        IconButton(
          onPressed: () {
            customNavigator(
              context,
              NotificationsUI(key: key, person: person),
            );
          },
          icon: Icon(Entypo.bell),
        ),
      ],
    );
  }
}
