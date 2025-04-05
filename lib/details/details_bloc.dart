// class DetailsBloc {
//   void _scrollToBottom() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         _scrollController.position.maxScrollExtent,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   void _onSubmit(int senderID) async {
//     if (controller.text.trim().isNotEmpty) {
//       FirestoreService().addChatMessage(
//           widget.details.name,
//           RoomDetails(
//               date: MainBloc().getCurrentDateTime(),
//               text: controller.text,
//               senderID: senderID,
//               image: imageBytes));
//       widget.onUpdate();
//       controller.clear();
//       imageBytes = null;
//       Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
//     }
//   }

//   void _onDelete(RoomDetails message) async {
//     FirestoreService().deleteChatMessage(widget.details.name, message);
//     setState(() {
//       widget.details.chatConv.remove(message);
//     });
//   }

//   void _onUpdate(RoomDetails oldMessage, RoomDetails newMessage) async {
//     FirestoreService()
//         .editChatMessage(widget.details.name, oldMessage, newMessage);

//     // Update the chatConv list inside setState
//     setState(() {
//       // Find the index of the old message and update it
//       int index = widget.details.chatConv.indexOf(oldMessage);
//       if (index != -1) {
//         widget.details.chatConv[index] = newMessage;
//       }
//     });
//   }
// }
