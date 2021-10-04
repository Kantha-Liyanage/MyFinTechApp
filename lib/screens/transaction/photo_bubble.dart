import 'dart:io';
import 'package:flutter/material.dart';
import 'package:my_fintech_app/models/chat_message.dart';
import 'package:my_fintech_app/screens/transaction/full_screen_photo.dart';
import 'package:provider/provider.dart';

class PhotoBubble extends StatelessWidget {
  
  const PhotoBubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ChatMessage chatMessage = Provider.of<ChatMessage>(context, listen: true);

    Color messageColor;
    CrossAxisAlignment messageAlignment;
    BorderRadius messageRadius;

    messageColor = Colors.greenAccent.shade100;
    messageAlignment = CrossAxisAlignment.end;
    messageRadius = const BorderRadius.only(
      topLeft: Radius.circular(15.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0),
    );

    return Column(
      crossAxisAlignment: messageAlignment,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.fromLTRB(4, 4, 4, 16),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.5,
                  color: Colors.black.withOpacity(.20))
            ],
            color: messageColor,
            borderRadius: messageRadius,
          ),
          child: Stack(
            children: <Widget>[
              SizedBox(
                height: 300,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                  child: GestureDetector(
                    child: Image.file(File(chatMessage.imagePath)),
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FullScreenPhoto(chatMessage.imagePath)),
                      );
                    }
                  ),
                ),
              ),
              Positioned(
                bottom: 0.0,
                right: 0.0,
                child: Row(
                  children: <Widget>[
                    Text('Now',
                      style: Theme.of(context).textTheme.bodyText2),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
