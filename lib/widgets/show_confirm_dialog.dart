import 'package:flutter/material.dart';

Future<bool?> showConfirmDialog(context, title, content) async {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(false);
          },
          child: Text(
            'No',
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop(true);
          },
          child: Text('Yes'),
        ),
      ],
    ),
  );
}
