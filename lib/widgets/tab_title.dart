import 'package:flutter/material.dart';

class TabTitle extends StatelessWidget {
  final String text;

  const TabTitle(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 5),
      child: Text(text,
        style: Theme.of(context).textTheme.headline1,
      ),
    );
  }
}
