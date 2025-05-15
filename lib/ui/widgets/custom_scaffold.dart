import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  final AssetImage bgImage;
  final Widget child;
  final AppBar? appBar;

  const CustomScaffold({
    required this.bgImage,
    required this.child,
    this.appBar,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: bgImage,
            fit: BoxFit.cover,
          ),
        ),
        child: child,
      ),
    );
  }
}
