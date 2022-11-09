import 'package:flutter/material.dart';

import '../styles/layout.dart';

void MySnackBar(context, message) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: Duration(seconds: Layout.SNACK_BAR_DURATION),
    ),
  );
}
