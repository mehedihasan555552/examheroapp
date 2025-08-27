
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mission_dmc/controllers/auth_controller.dart';

class ChatView extends GetView {
  ChatView(
      {super.key,
      required this.chatId,
      required this.peerUsername,
      required this.peerUserId});
  final String chatId, peerUsername;
  final int peerUserId;
  final AuthController _authController = Get.find();
 // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _controllerText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat with #$peerUsername'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Column(
        children: [
          // Chat body
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: _firestore!
          //         .collection('chats/messages/$chatId')
          //         .orderBy('timestamp')
          //         .snapshots(),
          //     builder: (BuildContext context,
          //         AsyncSnapshot<QuerySnapshot> snapshot) {
          //       if (snapshot.hasError) {
          //         return const Text(
          //           'Something went wrong',
          //           style: TextStyle(fontSize: 15, color: Colors.white70),
          //         );
          //       }
          //
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //           child: CircularProgressIndicator(
          //               backgroundColor: Colors.white),
          //         );
          //       }
          //
          //       // return ListView(
          //       //   children:
          //       //       snapshot.data!.docs.map((DocumentSnapshot document) {
          //       //     Map<String, dynamic> data =
          //       //         document.data()! as Map<String, dynamic>;
          //       //     return ListTile(
          //       //       title: Text(data['full_name']),
          //       //       subtitle: Text('${data['timestamp'].toString()}'),
          //       //     );
          //       //   }).toList(),
          //       // );
          //       final messages = snapshot.data?.docs.reversed;
          //       if (messages == null) {
          //         return Container();
          //       }
          //       return ListView.builder(
          //           reverse: true,
          //           itemCount: messages.length,
          //           itemBuilder: (context, index) {
          //             var message = messages.elementAt(index);
          //             final messageText = message.get('text');
          //             final messageSenderName = message.get('sender_name');
          //             final messageSenderId = message.get('sender_id');
          //             final timestamp = message.get('timestamp');
          //             return MessageBubble(
          //               name: messageSenderName,
          //               text: messageText,
          //               senderId: messageSenderId,
          //               uid: _authController.profile.value.user!.uid!,
          //               timestamp: timestamp,
          //             );
          //             // return Text('eee');
          //           });
          //     },
          //   ),
          // ),
          //  Chat actions
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controllerText,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.teal)),
                      prefixIcon: Icon(
                        Icons.chat_outlined,
                        color: Colors.blueGrey,
                      ),
                      // hintText: 'Write message'
                    ),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ),
                GestureDetector(
                  child: Icon(
                    Icons.send,
                    size: 56,
                    color: Theme.of(context).primaryColor,
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    String text = _controllerText.text.trim();
                    if (text.isNotEmpty) {
                      //Original Message
                      // _firestore
                      //     .collection('chats/messages/$chatId')
                      //     .add({
                      //       'sender_name':
                      //           _authController.profile.value.full_name,
                      //       'sender_id':
                      //           _authController.profile.value.user!.uid!,
                      //       'text': text,
                      //       'timestamp': DateTime.now().toString(),
                      //     })
                      //     .then((value) => {_controllerText.clear()})
                      //     .catchError((error) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(
                      //           content: Text(
                      //             'Can\'t send message',
                      //           ),
                      //           backgroundColor: Colors.red,
                      //         ),
                      //       );
                      //     });
                      // //Owner copy for showing on Own Message List
                      // _firestore
                      //     .collection(
                      //         'chats/${_authController.profile.value.user!.uid!}/message-list')
                      //     .doc(chatId)
                      //     .set({
                      //   'sender_name': _authController.profile.value.full_name,
                      //   'sender_id': _authController.profile.value.user!.uid!,
                      //   'text': text,
                      //   'timestamp': DateTime.now().toString(),
                      //   'peerUsername': peerUsername,
                      //   'peerUserId': peerUserId,
                      //   'chatId': chatId,
                      // });
                      // //Admin copy for showing on Admin Message List
                      // // _firestore
                      //     .collection('chats/$peerUserId/message-list')
                      //     .doc(chatId)
                      //     .set({
                      //   'sender_name': _authController.profile.value.full_name,
                      //   'sender_id': _authController.profile.value.user!.uid!,
                      //   'text': text,
                      //   'timestamp': DateTime.now().toString(),
                      //   'peerUsername': _authController.profile.value.full_name,
                      //   'peerUserId': _authController.profile.value.user!.uid!,
                      //   'chatId': chatId,
                      // });
                    }
                  },
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String name, text;
  final int senderId, uid;
  final dynamic timestamp;
  const MessageBubble(
      {super.key,
      required this.name,
      required this.text,
      required this.senderId,
      required this.uid,
      required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment:
            senderId == uid ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 15, color: Colors.white),
          ),
          Material(
            borderRadius: senderId == uid
                ? const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : const BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5,
            color: senderId == uid
                ? Theme.of(context).primaryColor.withOpacity(.7)
                : Colors.blueGrey.shade700,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Text(
                text,
                style: const TextStyle(color: Colors.white, fontSize: 15),
              ),
            ),
          ),
          SizedBox(
            height: 4,
          ),
          Text(
            DateFormat.yMMMEd()
                .add_jm()
                .format(DateTime.parse(timestamp.toString()).toLocal()),
            style: const TextStyle(fontSize: 12, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}
