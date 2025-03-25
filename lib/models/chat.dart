
import 'dart:typed_data';

class ChatRoom {
  final String name;
  final String image;
  //final String date;
  final List<RoomDetails> chatConv;

  ChatRoom({
    required this.name,
    required this.image,
   // required this.date,
    required this.chatConv,
  });
}

class RoomDetails {
  final String date;
  final String text;
  final int senderID;
  final Uint8List ?image;

  RoomDetails({required this.date, required this.text, required this.senderID,this.image});
}
