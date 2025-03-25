import 'package:bloc_example/models/chat.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  const ChatTile({super.key, required this.message});
  final RoomDetails message;

  @override
  Widget build(BuildContext context) {
    return Align(
     // alignment: message.isSender?Alignment.centerLeft: Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
       //  color:message.isSender? const Color.fromARGB(255, 157, 228, 156):Colors.grey,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (message.image != null && message.image!.isNotEmpty)
              Image.memory(
                message.image!,
                fit: BoxFit.cover,
                height: 150,
                width: 150,
              ),
            Text(
              message.text,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            SizedBox(height: 5),
            Text(
              message.date,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
