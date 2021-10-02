
import 'package:flutter/material.dart';

class SuggestionsBar extends StatelessWidget {
  const SuggestionsBar({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.grey.shade300,
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Cash',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Cash',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: TextButton(
                onPressed: () {},
                child: const Text(
                  'Cash',
                  style: TextStyle(color: Colors.black87),
                ),
              ),
            ),
          ],
        ));
  }
}