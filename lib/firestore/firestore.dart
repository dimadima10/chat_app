import 'package:bloc_example/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  static const collectionName="chat";
Stream<QuerySnapshot> chatStream = FirebaseFirestore.instance.collection(collectionName).snapshots();

Future<void> add(ChatRoom chat) {
  CollectionReference chats = FirebaseFirestore.instance.collection(collectionName);
  
  return chats.doc(chat.name).update({
    'image':chat.image,
    'list':chat.chatConv,
  })
  .then((value) => print("User added successfully!"))
  .catchError((error) => print("Failed to add user: $error"));
}
Future<void> fetchRoom() {
  CollectionReference chats = FirebaseFirestore.instance.collection(collectionName);
  
  return chats.get()
    .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        print('${doc.id} => ${doc.data()}');
      });
    })
    .catchError((error) => print("Failed to fetch users: $error"));
}
}