import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static const collectionName = "chat_rooms";
  static Stream<QuerySnapshot> chatStream =
      FirebaseFirestore.instance.collection(collectionName).snapshots();

  Stream<DocumentSnapshot<Object?>> getDocumentsStream(String docName) {
    return FirebaseFirestore.instance
        .collection(collectionName)
        .doc(docName)
        .snapshots();
  }

  static CollectionReference chats =
      FirebaseFirestore.instance.collection(collectionName);
 Future<String> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      // Create a reference to Firebase Storage with a unique file name
      final storageRef = FirebaseStorage.instance.ref().child('chat_images/$fileName');
      
      // Upload the image data
      await storageRef.putData(imageBytes);

      // Get the image URL after the upload is complete
      String imageUrl = await storageRef.getDownloadURL();

      return imageUrl;  // Return the URL of the uploaded image
    } catch (e) {
      print("Error uploading image: $e");
      return ''; 
    }
  }
 Future<void> createGroupRoom({
    required String name,
    Uint8List? imageBytes,
    required List<int> members,
  }) async {
    String? imageUrl;

    // Upload group image to Firebase Storage if provided
    if (imageBytes != null) {
      final ref = FirebaseStorage.instance
          .ref()
          .child('group_images')
          .child('$name.jpg');
      final upload = await ref.putData(imageBytes);
      imageUrl = await upload.ref.getDownloadURL();
    }

    final groupRoomData = {
      'name': name,
      'image': imageUrl ?? '',
      'members': members,
      'List': [],
      'createdAt': DateTime.now().toIso8601String(),
    };

    await chats.doc(name).set(groupRoomData).then((_) {
      print("Group '$name' created!");
    }).catchError((error) {
      print("Failed to create group: $error");
    });
  }

  Future<void> addChatMessage(String roomName, RoomDetails message) async {
    // TODO: add actual image     
  String imageUrl = "";

  if (message.image != null) {
    final storageRef = FirebaseStorage.instance
        .ref()
        .child('chat_images')
        .child('$roomName-${DateTime.now().millisecondsSinceEpoch}.jpg');

    final uploadTask = await storageRef.putData(message.image!);
    imageUrl = await uploadTask.ref.getDownloadURL();
  }
    return chats
        .doc(roomName)
        .update({
          'List': FieldValue.arrayUnion([
            {
              'date': message.date,
              'text': message.text,
              'senderId': message.senderID,
              'image': "",
            }
          ]),
        })
        .then((_) => print("Message added successfully!"))
        .catchError((error) => print("Failed to add message: $error"));
  }

  Future<void> deleteChatMessage(String roomName, RoomDetails message) {
    // TODO: add actual image
    return chats
        .doc(roomName)
        .update({
          'List': FieldValue.arrayRemove([
            {
              'date': message.date,
              'text': message.text,
              'senderId': message.senderID,
              'image': "",
            }
          ]),
        })
        .then((_) => print("Message deleted successfully!"))
        .catchError((error) => print("Failed to delete message: $error"));
  }

  Future<void> editChatMessage(
      String roomName, RoomDetails oldMessage, RoomDetails newMessage) async {
    try {
      DocumentSnapshot docSnapshot = await chats.doc(roomName).get();
      if (docSnapshot.exists) {
        Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
        List<dynamic> chatConv = data['List'];

        for (int i = 0; i < chatConv.length; i++) {
          if (chatConv[i]['date'] == oldMessage.date &&
              chatConv[i]['senderId'] == oldMessage.senderID &&
              chatConv[i]['text'] == oldMessage.text) {
            chatConv[i] = {
              'date': newMessage.date,
              'text': newMessage.text,
              'senderId': newMessage.senderID,
              'image': newMessage.image ?? "",
            };
            break;
          }
        }

        await chats.doc(roomName).update({
          'List': chatConv,
        });

        print("Message updated successfully!");
      } else {
        print("Chat room not found!");
      }
    } catch (error) {
      print("Failed to update message: $error");
    }
  }
}
