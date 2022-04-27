import 'package:clubhouse_clone/meeting/meeting_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  final MeetingStore meetingStore;

  const ChatView({required this.meetingStore, Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  late MeetingStore _meetingStore;
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";

  @override
  void initState() {
    super.initState();
    _meetingStore = widget.meetingStore;
  }

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
              Expanded(
                // child: const Text('No messages')
                child: Observer(
                  builder: (_) {
                    if (!_meetingStore.isMeetingStarted) {
                      return const SizedBox();
                    }
                    if (_meetingStore.messages.isEmpty) {
                      return const Text('No messages');
                    }
                    return ListView(
                      children: List.generate(
                        _meetingStore.messages.length,
                        (index) => Container(
                          padding: const EdgeInsets.all(5.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _meetingStore
                                              .messages[index].sender?.name ??
                                          "",
                                      style: const TextStyle(
                                          fontSize: 10.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                  Text(
                                    formatter.format(
                                        _meetingStore.messages[index].time),
                                    style: const TextStyle(
                                        fontSize: 10.0,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w900),
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                _meetingStore.messages[index].message
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          ),
                          decoration: const BoxDecoration(
                              border: Border(
                            left: BorderSide(
                              color: Colors.blue,
                              width: 5,
                            ),
                          )),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.only(top: 10.0),
                child: Row(
                  children: [
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
                        String message = messageTextController.text;
                        if (message.isEmpty) return;
                        if (valueChoose == "Everyone") {
                          _meetingStore.sendBroadcastMessage(message);
                        }
                        messageTextController.clear();
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
