import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String _text;
  const ErrorText(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      _text,
      style: TextStyle(color: Colors.red),
    );
  }
}
