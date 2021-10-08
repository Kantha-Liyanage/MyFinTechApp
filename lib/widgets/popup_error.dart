import 'package:flutter/material.dart';

class PopupError extends StatelessWidget {
  String message;
  PopupError(this.message, { Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> showErrorDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('FinChat'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  message + '\nPlease correct.',
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}