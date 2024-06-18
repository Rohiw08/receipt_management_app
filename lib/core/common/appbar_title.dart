import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class AppBarTitle extends StatelessWidget {
  const AppBarTitle({
    required this.appbarTitleText,
    super.key,
  });

  final String appbarTitleText;

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.titleLarge?.color;
    return Text(
      appbarTitleText,
      style: GoogleFonts.lato(
        color: textColor,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    );
  }
}
