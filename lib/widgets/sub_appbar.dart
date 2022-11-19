import 'package:flutter/material.dart';

import '../styles/layout.dart';

class SubAppbar extends StatelessWidget with PreferredSizeWidget {
  final String title;
  final Icon? icon;
  final VoidCallback? handler;

  SubAppbar(this.title, this.icon, this.handler);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: Layout.ELEVATION,
      title: Text(
        title,
				maxLines: 2,
        style: TextStyle(fontFamily: 'Oswald'),
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
