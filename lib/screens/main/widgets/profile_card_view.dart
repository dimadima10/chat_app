import 'package:bloc_example/screens/details/details_screen.dart';
import 'package:bloc_example/models/chat.dart';
import 'package:flutter/material.dart';

class ProfileCardView extends StatelessWidget {
  final ChatRoom details;
  const ProfileCardView({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: InkWell(
        onTap:
            () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) {
                    return DetailsScreen(details: details);
                  },
                ),
              ).then((s) {}),
            },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20.0,
              backgroundImage: NetworkImage(details.image),
              backgroundColor: Colors.transparent,
            ),

            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(details.name), Text(details.chatConv.last.text)],
            ),
            Expanded(child: SizedBox()),

          ],
        ),
      ),
    );
  }
}
