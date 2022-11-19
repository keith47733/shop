import 'package:flutter/material.dart';

import '../styles/layout.dart';

Widget ErrorMessage(context) {
  return Padding(
    padding: const EdgeInsets.all(Layout.SPACING * 4),
    child: Center(
      child: Text(
        'Unable to communicate with server. Please try again later',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    ),
  );
}