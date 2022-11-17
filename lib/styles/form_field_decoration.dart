import 'package:flutter/material.dart';

import 'layout.dart';

InputDecoration formFieldDecoration(context) {
	return InputDecoration(
      floatingLabelBehavior: FloatingLabelBehavior.always,
      labelStyle: Theme.of(context).textTheme.titleLarge,
      errorStyle: Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.error),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.onBackground, width: Layout.BORDER_WIDTH),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: Layout.BORDER_WIDTH),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: Layout.BORDER_WIDTH),
      ),
    );
}