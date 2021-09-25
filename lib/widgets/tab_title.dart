import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  String text;

  TabTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
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
