import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
        	'assets/images/shopping.png',
        	height: MediaQuery.of(context).size.width * 0.6,
        	width: MediaQuery.of(context).size.width * 0.6,
        ),
      ),
    );
  }
}
