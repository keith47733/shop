import 'package:flutter/material.dart';

import '../styles/layout.dart';

class MyAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  final String title;
  final Icon? icon;
  final VoidCallback? handler;

  MyAppBar(this.title, this.icon, this.handler);

  @override
  Widget build(BuildContext context) {
    return AppBar(
			elevation: Layout.ELEVATION,
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Merriweather'),
      ),
      actions: [
        if (icon != null && handler != null)
          Padding(
            padding: const EdgeInsets.only(right: Layout.SPACING / 2),
            child: IconButton(
              onPressed: handler!,
              icon: icon!,
            ),
          )
        else
          SizedBox.shrink(),
      ],
    );
  }
}
