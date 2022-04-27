import 'package:clubhouse_clone/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class RoomView extends StatefulWidget {
  final String roomTitle;
  final String roomLink;
  final String username;
  const RoomView(
      {required this.roomTitle,
      required this.roomLink,
      required this.username,
      Key? key})
      : super(key: key);

  @override
  _RoomViewState createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.amberAccent.shade100,
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.black,
            )),
      ),
      body: Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(22), topRight: Radius.circular(22))),
        padding:
            const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.roomTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 30,
            ),
            // Render the peers
            Row(
              children: [
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.grey.shade300,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {
                      // Leave peer
                      Navigator.pop(context);
                    },
                    child: const Text(
                      '✌️ Leave quietly',
                      style: TextStyle(color: Colors.redAccent),
                    )),
                const Spacer(),
                //Toogle Audio
                OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.grey.shade300,
                        padding: EdgeInsets.zero,
                        shape: const CircleBorder()),
                    onPressed: () {
                      _scaffoldKey.currentState!.openEndDrawer();
                    },
                    child: const Icon(Icons.chat))
              ],
            )
          ],
        ),
      ),
      // Uncomment for Chat view
      // endDrawer: ChatView(meetingStore: _meetingStore),
    );
  }
}
