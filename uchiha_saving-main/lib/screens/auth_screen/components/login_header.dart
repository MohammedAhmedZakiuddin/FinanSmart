import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginHeader extends StatelessWidget {
  final String title;
  const LoginHeader({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _size = MediaQuery.of(context).size;

    return Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.ubuntu(fontSize: _size.height * 0.045),
    );
  }
}
