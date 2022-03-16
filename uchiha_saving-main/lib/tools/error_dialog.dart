import 'package:flutter/material.dart';

void errorDialog(
    {required String title,
    required String content,
    required BuildContext context}) {
  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
    ),
  );
}
