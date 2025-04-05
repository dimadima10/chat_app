import 'package:chat_app/Services/FirestoreServices.dart';
import 'package:chat_app/models/chat.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  Function? onDelete;
  Function? onUpdate;
  final int nickname;
  final RoomDetails message;

  ChatTile(
      {super.key,
      required this.message,
      this.onDelete,
      this.onUpdate,
      required this.nickname});

  @override
  _ChatTileState createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  late TextEditingController _controller;
  bool isEditing = false; // Track whether the message is being edited

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.message.text);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                widget.onDelete!();
                print('Message deleted');
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _handleUpdate() {
    widget.onUpdate!(widget.message.text, _controller.text);
    setState(() {
      isEditing = false; // Stop editing after updating
    });
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: widget.message.senderID == widget.nickname
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: widget.message.senderID == widget.nickname
              ? Colors.blueGrey[400]
              : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          width: 300,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                 // Display image if imageUrl exists, otherwise use the image byte (image)
                  if (widget.message.imageUrl != null &&
                      widget.message.imageUrl!.isNotEmpty)
                    Image.network(
                      widget.message.imageUrl!,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return SizedBox(
                          height: 150,
                          width: 150,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) =>
                          Icon(Icons.broken_image),
                    )
                  else if (widget.message.image != null &&
                      widget.message.image!.isNotEmpty)
                    Image.memory(
                      widget.message.image!,
                      fit: BoxFit.cover,
                      height: 150,
                      width: 150,
                    ),
                  isEditing
                      ? Container(
                          width: 200, // Set width if needed
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: TextField(
                              controller: _controller,
                              maxLines: null,
                              decoration: InputDecoration(
                                hintText: "Edit message",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        )
                      : Text(
                          widget.message.text,
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                  SizedBox(height: 5),
                  Text(
                    widget.message.date,
                    style: TextStyle(
                        fontSize: 12,
                        color: widget.message.senderID == 1
                            ? Colors.grey[200]
                            : Colors.grey[700]),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              widget.message.senderID == widget.nickname
                  ? InkWell(
                      onTap: () {
                        setState(() {
                          isEditing = !isEditing; // Toggle the editing state
                        });
                      },
                      child: Icon(Icons.edit),
                    )
                  : Container(),
              const SizedBox(
                width: 6,
              ),
              if (isEditing)
                InkWell(
                  onTap: _handleUpdate,
                  child: Icon(Icons.check),
                ),
              const SizedBox(
                width: 6,
              ),
              widget.message.senderID == widget.nickname
                  ? InkWell(
                      onTap: () {
                        _showDeleteConfirmationDialog(context);
                      },
                      child: Icon(Icons.delete),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
