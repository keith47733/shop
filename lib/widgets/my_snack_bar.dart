import 'package:flutter/material.dart';

import '../styles/layout.dart';

void MySnackBar(context, content) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
			elevation: Layout.ELEVATION,
      content: Text(content),
      duration: Duration(seconds: Layout.SNACK_BAR_DURATION),
    ),
  );
}
