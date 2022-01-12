import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class Chat_Screen extends StatefulWidget {
  const Chat_Screen({Key? key}) : super(key: key);

  static const String id = "chat";

  @override
  _Chat_ScreenState createState() => _Chat_ScreenState();
}

class _Chat_ScreenState extends State<Chat_Screen> {
  final messageController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String messageText;
  late Timestamp time;

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection("messages").snapshots()) {
      for (var message in snapshot.docs) {
        print(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Icon(Icons.arrow_back_ios),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  _auth.signOut();
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.close,
                ),
              ),
            )
          ],
          backgroundColor: Colors.orangeAccent,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "images/logo.png",
                scale: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Text("Chats"),
            ],
          )),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection("messages")
                  .orderBy('created', descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }

                final messages = snapshot.data!.docs.reversed;
                List<MessageBubble> messageBubbles = [];
                for (var message in messages) {
                  final messageText = message.get('text');
                  final messageSender = message.get('user');
                  final time = message.get('created');

                  final currentUser = loggedInUser.email;

                  final messageBubble = MessageBubble(
                    sender: messageSender,
                    text: messageText,
                    isMe: currentUser == messageSender,
                    created: time,
                  );
                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: ListView(
                      reverse: true,
                      children: messageBubbles,
                    ),
                  ),
                );
              }),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 50,
                  width: 260,
                  child: TextField(
                    controller: messageController,
                    onChanged: (value) {
                      messageText = value;
                      messagesStream();
                    },
                    keyboardType: TextInputType.text,
                    // textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Message',
                      hintStyle: TextStyle(fontSize: 15),
                      enabledBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.grey, width: 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                            color: Colors.orangeAccent, width: 1.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 15.0, top: 5),
                child: Container(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: () {
                      messageController.clear();
                      _firestore.collection("messages").add({
                        "text": messageText,
                        "user": loggedInUser.email,
                        'created': FieldValue.serverTimestamp()
                      });
                    },
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        )),
                    child: Text("Send"),
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatefulWidget {
  final String? sender;
  final String text;
  final Timestamp? created;
  final bool? isMe;
  const MessageBubble(
      {Key? key,
      required this.sender,
      required this.text,
      required this.created,
      required this.isMe})
      : super(key: key);

  @override
  _MessageBubbleState createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  var timeSent;
  var dateSent;
//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

// class MessageBubble extends StatelessWidget {
//   MessageBubble(
//       {required this.sender,
//       required this.text,
//       required this.isMe,
//       required this.created});

//   final String sender;
//   final String text;
//   final Timestamp created;
//   final bool isMe;

  setTimeStamp() {
    timeSent = widget.created?.toDate();
    timeSent = DateFormat('kk:mm').format(timeSent);
  }

  setDateStamp() {
    dateSent = widget.created?.toDate();
    dateSent = DateFormat('dd-MM').format(dateSent);
  }

  @override
  void initState() {
    setTimeStamp();
    setDateStamp();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            widget.isMe! ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Center(child: widget.created == null ? Text('') : Text("$dateSent")),
          Text(
            widget.sender!,
            style: TextStyle(fontSize: 10, color: Colors.black54),
          ),
          Material(
            borderRadius: widget.isMe!
                ? BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    topRight: Radius.circular(30),
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30)),
            elevation: 5.0,
            color: widget.isMe! ? Colors.orangeAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                widget.text,
                style: TextStyle(
                    fontSize: 15,
                    color: widget.isMe! ? Colors.white : Colors.black),
              ),
            ),
          ),
          Text(
            "$timeSent",
            style: TextStyle(color: Colors.black38, fontSize: 13.0),
          )
        ],
      ),
    );
  }
}
