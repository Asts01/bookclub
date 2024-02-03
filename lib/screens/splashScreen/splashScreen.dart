import 'package:bookclub/utils/ourTheme.dart';
import 'package:flutter/material.dart';

class OurSplashScreen extends StatelessWidget {
  const OurSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ourTheme().lightGreen,
      body: Center(
        child: Text('loading...'),
      ),
    );
  }
}
