import 'package:chat_app/Services/FirestoreServices.dart';
import 'package:chat_app/mainScreen/main_bloc.dart';
import 'package:chat_app/mainScreen/widgets/profile_card_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/chat.dart';

class MainScreen extends StatefulWidget {
  final int nickname;
  const MainScreen({super.key, required this.nickname});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // List<ChatRoom> chatRooms = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        "Chats",
        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      )),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirestoreService.chatStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                MainBloc().fillList(snapshot.data!);
                return MainBloc.chatRooms.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: MainBloc.chatRooms.length,
                        itemBuilder: (ctx, index) {
                          return ProfileCardView(
                            details: MainBloc.chatRooms[index],
                            nickname: widget.nickname,
                          );
                        },
                      );
            }
          }),
    );
  }
}
