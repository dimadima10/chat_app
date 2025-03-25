import 'dart:typed_data';

import 'package:bloc_example/models/chat.dart';
import 'package:bloc_example/screens/main/main_bloc.dart';
import 'package:bloc_example/screens/details/widgets/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailsScreen extends StatefulWidget {
  final ChatRoom details;

  const DetailsScreen({super.key, required this.details});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {

  TextEditingController myController = TextEditingController();
  Uint8List? imageBytes;
  final ImagePicker _picker = ImagePicker();
  bool flag = true;

   @override
  void initState() {
    super.initState();
    getRoomDetails(); 
  }

Future<void> getRoomDetails() {
  CollectionReference room1 = FirebaseFirestore.instance.collection('room1');
  
  return room1.get()
    .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      }); //might have to add a setstate?
    })
    .catchError((error) => print("Failed to fetch users: $error"));
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: flag ? Colors.white : Colors.black,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(widget.details.image),
              backgroundColor: Colors.transparent,
            ),
            Text(widget.details.name),
            Spacer(),
            IconButton(
              onPressed: () {
                flag = !flag;
                setState(() {});
              },
              icon: Icon(Icons.dark_mode),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.details.chatConv.length,
              itemBuilder: (context, index) {
                // final msg = widget.details.chatConv[index];
                return ChatTile(message: widget.details.chatConv[index]);
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 221, 220, 221),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  if (imageBytes != null) // image preview
                    // Padding(
                    //  padding: const EdgeInsets.only(right: 8.0),
                    //    Expanded(
                    // child: GestureDetector(
                    //     onTap: () {
                    //       setState(() {
                    //         imageBytes = null; // Remove image preview
                    //       });
                    //     },
                    //     child: Stack(
                    //       children: [
                    //         Image.memory(
                    //           imageBytes!,
                    //           width: 40,
                    //           height: 40,
                    //           fit: BoxFit.cover,
                    //         ),
                    //         Icon(Icons.close, size: 10),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  Expanded(
                    child: TextField(
                      controller: myController,
                      decoration: InputDecoration(hintText: "Enter message..."),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // getImage();
                    },
                    icon: Icon(Icons.attachment),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        widget.details.chatConv.add(
                          RoomDetails(
                            date: MainBloc().getCurrentDateTime(),
                            text: myController.text,
                           // isSender: false,
                            image: imageBytes,
                             senderID: 3,
                          ),
                        );
                        myController.clear();
                        imageBytes = null;
                      });
                    },
                    icon: Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
