import 'dart:io';

import 'package:flutter/material.dart';

class FullScreenPhoto extends StatelessWidget {
  String imagePath;
  FullScreenPhoto(this.imagePath, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photo View')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: InteractiveViewer(
        panEnabled: true, // Set it to false to prevent panning. 
        boundaryMargin: const EdgeInsets.all(0),
        minScale: 1,
        maxScale: 5, 
        child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: FileImage(File(imagePath)),
                fit: BoxFit.cover,
              ),
            ),
        ),
      ), 
    );
  }
}
