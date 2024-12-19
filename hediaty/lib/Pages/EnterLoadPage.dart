import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatefulWidget {
  LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  String loading_title = "Logging in";
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.white,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      LoadingAnimationWidget.newtonCradle(color: Colors.red, size: 200),
      //Text(loading_title)
    ])));
  }
}
