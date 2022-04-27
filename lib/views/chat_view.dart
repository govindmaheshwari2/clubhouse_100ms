import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";


  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Chat"),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: const Icon(
                Icons.clear,
                color: Colors.black,
                size: 25.0,
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
                    // Message Render
                    Expanded(
                      child: TextField(
                        autofocus: true,
                        controller: messageTextController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            hintText: "Type a Message"),
                      ),
                    ),
                    const SizedBox(width: 15),
                    GestureDetector(
                      onTap: () {
                        // Send Message on Button Press
                      },
                      child: const Icon(
                        Icons.send,
                        size: 40.0,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
