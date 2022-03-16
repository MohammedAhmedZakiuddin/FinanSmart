import 'dart:math';

import 'package:flutter/material.dart';
import 'package:theme_provider/theme_provider.dart';

Color getRandomColor(BuildContext context) =>
    ThemeProvider.themeOf(context).id == "light"
        ? Colors.primaries[Random().nextInt(Colors.primaries.length)].shade100
        : Colors.primaries[Random().nextInt(Colors.primaries.length)].shade800;
