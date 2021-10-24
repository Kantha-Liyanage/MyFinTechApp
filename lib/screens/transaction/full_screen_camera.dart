import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/models/chat_messages_list.dart';
import 'package:my_fintech_app/services/chart_service.dart';
import 'package:provider/provider.dart';
import 'package:image/image.dart' as img;

class FullScreenCamera extends StatefulWidget {
  final CameraDescription camera;
  final VoidCallback scrollChatToBottom;

  const FullScreenCamera(this.camera, this.scrollChatToBottom, {Key? key})
      : super(key: key);

  @override
  _FullScreenCameraState createState() => _FullScreenCameraState();
}

class _FullScreenCameraState extends State<FullScreenCamera> {
  late final CameraController _controller;
  late Future<void> _initializeControllerFuture;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ChatMessagesList chatMessages =
        Provider.of<ChatMessagesList>(context, listen: true);

    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //How I made the camera to show in fullscreen mode
            //https://medium.com/lightsnap/making-a-full-screen-camera-application-in-flutter-65db7f5d717b
            final size = MediaQuery.of(context).size;
            final deviceRatio = size.width / size.height;
            final xScale = _controller.value.aspectRatio / deviceRatio;
            // Modify the yScale if you are in Landscape
            final yScale = 1.0;

            return AspectRatio(
              aspectRatio: deviceRatio,
              child: Transform(
                alignment: Alignment.center,
                transform: Matrix4.diagonal3Values(xScale, yScale, 1),
                child: CameraPreview(_controller),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;

            final image = await _controller.takePicture();

            await _fixRotation(image.path);

            ChatMessage msg = ChatMessage.photo(
                image.path, ChatMessageType.userMessage, 'Today', 'Now');
            chatMessages.add(msg);
            ChatService().createMessage(msg);

            Navigator.pop(context);
            widget.scrollChatToBottom();
          } catch (e) {}
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }

  Future<File> _fixRotation(String imagePath) async {
    final originalFile = File(imagePath);
    List<int> imageBytes = await originalFile.readAsBytes();
    final originalImage = img.decodeImage(imageBytes);

    int height = originalImage!.height;
    int width = originalImage.width;
    // Let's check for the image size
    // This will be true also for upside-down photos but it's ok for me
    if (height >= width) {
      // I'm interested in portrait photos so
      // I'll just return here
      return originalFile;
    }

    img.Image fixedImage = img.copyRotate(originalImage, 90);
    final fixedFile =
        await originalFile.writeAsBytes(img.encodeJpg(fixedImage));
    return fixedFile;
  }
}
