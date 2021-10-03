import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class FullScreenCamera extends StatefulWidget {

  final CameraDescription camera;

  FullScreenCamera(this.camera, {Key? key}) : super(key: key);

  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(
      widget.camera,
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    final xScale = _controller.value.aspectRatio / deviceRatio;
    // Modify the yScale if you are in Landscape
    const yScale = 1.0;

    return Container(
      child: AspectRatio(
        aspectRatio: deviceRatio,
        child: Transform(
          alignment: Alignment.center,
          transform: Matrix4.diagonal3Values(xScale, yScale, 1),
          child: CameraPreview(_controller),
        ),
      ),
    );
  }
}
