import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:intl/intl.dart';

class ChatView extends StatefulWidget {
  final List<HMSMessage> messages;
  final HMSSDK hmsSDK;
  final HMSActionResultListener listener;
  const ChatView({required this.messages, required this.hmsSDK,required this.listener, Key? key})
      : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  TextEditingController messageTextController = TextEditingController();
  String valueChoose = "Everyone";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd hh:mm a');
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: SafeArea(
        child: FractionallySizedBox(
          heightFactor: 0.81,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 14.0),
                          child: Row(
                            children: const [
                              Text(
                                "Chat",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 15),
                  child: Divider(
                    height: 5,
                    color: Colors.grey.shade700,
                  ),
                ),
                Expanded(
                    child: ListView.builder(
                  itemCount: widget.messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10),
                      child: Container(
                        padding: const EdgeInsets.all(5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.messages[index].sender?.name ?? "",
                                    style: const TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Text(
                                  formatter.format(widget.messages[index].time),
                                  style: const TextStyle(
                                      fontSize: 10.0,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 10.0,
                            ),
                            Text(
                              widget.messages[index].message.toString(),
                              style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w300),
                            ),
                          ],
                        ),
                        decoration: BoxDecoration(
                          borderRadius: (widget.messages[index].sender?.isLocal??false)
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10))
                              : const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10)),
                          color: (widget.messages[index].sender?.isLocal??false)
                              ? Colors.green
                              : Colors.blue,
                        ),
                      ),
                    );
                  },
                )),
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
                            widget.hmsSDK
                                .sendBroadcastMessage(message: message,hmsActionResultListener: widget.listener);
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
      ),
    );
  }
}
