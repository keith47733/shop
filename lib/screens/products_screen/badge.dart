import 'package:flutter/material.dart';

import '../../styles/layout.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final String value;

  const Badge({
    required this.child,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          right: 6 + Layout.SPACING / 2,
          top: 6,
          child: Container(
            padding: EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Theme.of(context).colorScheme.secondary,
            ),
            constraints: BoxConstraints(
              minWidth: 20,
              minHeight: 20,
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: Text(
                key: ValueKey(value),
                value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
          ),
        )
      ],
    );
  }
}
