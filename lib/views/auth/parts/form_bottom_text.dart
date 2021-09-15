import 'package:flutter/material.dart';

class FormBottomText extends StatelessWidget {
  const FormBottomText({
    Key? key,
    required this.message,
    required this.actionMessage,
    required this.action,
  }) : super(key: key);

  final String? message;
  final String? actionMessage;
  final VoidCallback? action;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          message!,
          style: TextStyle(
            fontSize: 16.0,
          ),
        ),
        TextButton(
          onPressed: action,
          child: Text(
            actionMessage!,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          style: ButtonStyle(
            overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
          ),
        )
      ],
    );
  }
}
