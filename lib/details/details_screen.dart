import 'dart:typed_data';
import 'package:chat_app/Services/FirestoreServices.dart';
import 'package:chat_app/details/widgets/chat_tile.dart';
import 'package:chat_app/mainScreen/main_bloc.dart';
import 'package:chat_app/models/chat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:image_picker/image_picker.dart';

class DetailsScreen extends StatefulWidget {
  final ChatRoom details;
  final int nickname;
  final Function() onUpdate;
  const DetailsScreen(
      {super.key,
      required this.details,
      required this.onUpdate,
      required this.nickname});

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool isDark = false;

  Uint8List? imageBytes;
  final ImagePicker _picker = ImagePicker();

  bool flag = true;

  Future<void> getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      Uint8List pickedImageBytes = await pickedFile.readAsBytes();
      setState(() {
        imageBytes = pickedImageBytes;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _onSubmit(int senderID) async {
    if (controller.text.trim().isNotEmpty) {
      String imageUrl = ''; // Default is an empty string (no image URL)

      // If an image is selected, upload it and get the URL
      if (imageBytes != null) {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();

        // Upload the image to Firebase and get the URL
        imageUrl = await FirestoreService().uploadImage(imageBytes!, fileName);
      }

      // Add the message to Firestore with the image URL (if any)
      FirestoreService().addChatMessage(
        widget.details.name,
        RoomDetails(
          date: MainBloc().getCurrentDateTime(),
          text: controller.text,
          senderID: senderID,
          imageUrl: imageUrl.isNotEmpty
              ? imageUrl
              : null, // Only set imageUrl if it's not empty
          image: imageBytes, // Store image bytes if needed for future use
        ),
      );

      widget.onUpdate();
      controller.clear();
      imageBytes = null;
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  void _onDelete(RoomDetails message) async {
    FirestoreService().deleteChatMessage(widget.details.name, message);
    setState(() {
      widget.details.chatConv.remove(message);
    });
  }

  void _onUpdate(RoomDetails oldMessage, RoomDetails newMessage) async {
    FirestoreService()
        .editChatMessage(widget.details.name, oldMessage, newMessage);
    setState(() {
      int index = widget.details.chatConv.indexOf(oldMessage);
      if (index != -1) {
        widget.details.chatConv[index] = newMessage;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDark ? Colors.blueGrey[900] : Colors.white,
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(widget.details.image),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 10),
            Text(widget.details.name),
          ],
        ),
        actions: [
          // IconButton(
          //   icon: const Icon(Icons.group_add),
          //   onPressed: _createNewGroup,
          //   tooltip: 'Create new group',
          // ),
          IconButton(
              onPressed: () {
                isDark = !isDark;
                setState(() {});
              },
              icon: const Icon(Icons.dark_mode))
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirestoreService().getDocumentsStream(widget.details.name),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) return Text('${snapshot.error}');
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                _fillTheList(snapshot.data!);
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: widget.details.chatConv.length,
                        itemBuilder: (ctx, index) {
                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ChatTile(
                                message: widget.details.chatConv[index],
                                nickname: widget.nickname,
                                onDelete: () {
                                  _onDelete(widget.details.chatConv[index]);
                                },
                                onUpdate: (String oldtext, String newtext) {
                                  RoomDetails oldMessage = RoomDetails(
                                      date: widget.details.chatConv[index].date,
                                      text: oldtext,
                                      senderID: 1);
                                  RoomDetails newMessage = RoomDetails(
                                      date: MainBloc().getCurrentDateTime(),
                                      text: newtext,
                                      senderID: 1);
                                  _onUpdate(oldMessage, newMessage);
                                },
                              ));
                        },
                      ),
                    ),
                    Container(
                      color: Colors.blueGrey,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            if (imageBytes != null) // image preview
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      imageBytes = null;
                                    });
                                  },
                                  child: Stack(
                                    children: [
                                      Image.memory(
                                        imageBytes!,
                                        width: 40,
                                        height: 40,
                                        fit: BoxFit.cover,
                                      ),
                                      const Icon(Icons.close, size: 10),
                                    ],
                                  ),
                                ),
                              ),
                            Expanded(
                              child: TextField(
                                onSubmitted: (value) =>
                                    _onSubmit(widget.nickname),
                                controller: controller,
                                decoration: InputDecoration(
                                    hintText: "Type a message...",
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        getImage();
                                        // _pickImage();
                                      },
                                      icon: const Icon(
                                        Icons.attachment,
                                      ),
                                    )),
                              ),
                            ),
                            IconButton(
                              onPressed: () => _onSubmit(widget.nickname),
                              icon: const Icon(Icons.send),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
            }
          }),
    );
  }

  _fillTheList(DocumentSnapshot<Object?> snapshot) {
    final chatConv = _mapToRoomDetailsList(snapshot['List'] as List<dynamic>?);
    widget.details.chatConv = chatConv;
    Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
  }

  List<RoomDetails> _mapToRoomDetailsList(List<dynamic>? chatList) {
    if (chatList == null) return [];

    return chatList.map((chat) => _mapToRoomDetails(chat)).toList();
  }

  RoomDetails _mapToRoomDetails(Map<String, dynamic> chat) {
    return RoomDetails(
      date: chat['date'] ?? '',
      text: chat['text'] ?? '',
      senderID: chat['senderId'] ?? 0,
      imageUrl: chat['image'] ?? '',
    );
  }
}
