import 'package:chat_app/details/details_screen.dart';
import 'package:chat_app/models/chat.dart';
import 'package:flutter/material.dart';

class ProfileCardView extends StatefulWidget {
  final ChatRoom details;
  final int nickname;

  // final Function onUpdate;
  const ProfileCardView(
      {super.key, required this.details, required this.nickname});

  @override
  State<ProfileCardView> createState() => _ProfileCardViewState();
}

class _ProfileCardViewState extends State<ProfileCardView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) {
              return DetailsScreen(
                details: widget.details,
                nickname: widget.nickname,
                onUpdate: () {
                  setState(() {});
                },
              );
            },
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 24.0,
              backgroundImage: NetworkImage(widget.details.image),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.details.name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
