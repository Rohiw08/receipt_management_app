import 'package:flutter/material.dart';

class TextWithLeadingIcon extends StatelessWidget {
  final Icon leading;
  final String title;

  const TextWithLeadingIcon({
    super.key,
    required this.leading,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 10),
          Flexible(
            child: Text(
              title,
            ),
          ),
        ],
      ),
    );
  }
}
