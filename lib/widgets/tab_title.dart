import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  final String text;

  const TabTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
      child: Text(text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.blue,
        )
      ),
    );
  }
}
