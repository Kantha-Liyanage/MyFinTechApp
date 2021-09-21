import 'package:flutter/material.dart';

class ChatBox extends StatelessWidget {
  
  ChatBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 5,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 0, 12),
            child: TextField(
              onChanged: (value) {},
              minLines: 1,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.grey.shade900),
                ),
                hintText: 'Type here...',
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(
                  Icons.keyboard,
                  color: Colors.grey.shade600,
                  size: 20,
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.photo_camera_sharp),
                  onPressed: (){},
                ),
              ),
            ),
          )
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
            child: ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.send_sharp),
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(12),
              ),
            )
          )
        )
      ],
    );
  }
}
