import 'package:flutter/material.dart';

class PopupConfirmation extends StatelessWidget {
  String message;
  VoidCallback action;

  PopupConfirmation(this.message, this.action, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  Future<void> showConfirmationDialog(BuildContext context) async {
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
                  message,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('YES'),
              onPressed: () {
                Navigator.of(context).pop();
                //External action
                action();
              },
            ),
            TextButton(
              child: const Text('NO'),
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
