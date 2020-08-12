import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
              'pictures/app.jpg',
              width: size.width,
              height: size.height,
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    );
  }
}
