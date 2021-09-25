import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountField extends StatefulWidget {
  String label;
  double amount;

  AmountField(this.label, this.amount, {Key? key}) : super(key: key);
  @override
  _AmountFieldState createState() => _AmountFieldState();

}

class _AmountFieldState extends State<AmountField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
          border: const UnderlineInputBorder(), labelText: widget.label + ' (Rs)'
      ),
      controller: TextEditingController()..text = widget.amount.toString(),
      keyboardType: TextInputType.number,
    );
  }
}
