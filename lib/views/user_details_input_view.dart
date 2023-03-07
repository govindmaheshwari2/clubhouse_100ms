import 'package:clubhouse_clone/services/utilities.dart';
import 'package:clubhouse_clone/views/room_view.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class UserDetailsInputView extends StatefulWidget {
  const UserDetailsInputView({Key? key}) : super(key: key);

  @override
  _UserDetailsInputViewState createState() => _UserDetailsInputViewState();
}

class _UserDetailsInputViewState extends State<UserDetailsInputView> {
  TextEditingController usernameTextEditingController = TextEditingController();

  String initial = "";
  String userRole = "speaker";

  @override
  void initState() {
    super.initState();
    Utilities.getPermissions();
    usernameTextEditingController.addListener(getUserNameInitial);
  }

  @override
  void dispose() {
    usernameTextEditingController.removeListener(getUserNameInitial);
    usernameTextEditingController.clear();
    usernameTextEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: Text(
                    '100MS Clubhouse Clone',
                    style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                CircleAvatar(
                  backgroundColor: Utilities.getBackgroundColour(
                      usernameTextEditingController.text),
                  radius: 50,
                  child: Text(initial, style: const TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white)),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Please enter your name",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white),
                  child: TextField(
                    keyboardType: TextInputType.name,
                    controller: usernameTextEditingController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter UserName',
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10)),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Join as",
                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: userRole == "speaker"
                                ? Colors.white
                                : Colors.black,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white)),
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                userRole = "speaker";
                              });
                            },
                            child: Text("Speaker",style: TextStyle(fontWeight: FontWeight.bold),))),
                    const SizedBox(
                      width: 20,
                    ),
                    Container(
                        height: 30,
                        decoration: BoxDecoration(
                            color: userRole == "listener"
                                ? Colors.white
                                : Colors.black,
                            borderRadius: BorderRadius.circular(22),
                            border: Border.all(color: Colors.white)),
                        child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                userRole = "listener";
                              });
                            },
                            child: const Text("Listener",style: TextStyle(fontWeight: FontWeight.bold),))),
                  ],
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => RoomView(
                                userRole: userRole,
                                username: usernameTextEditingController.text),
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22))),
                    child: const Text('Join Room')),
                const SizedBox(height: 20),
                    const Center(child: Text("Made with ❤️ by 100ms",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),))
              ],
            ),
          ),
        ),
      ),
    ));
  }

  void getUserNameInitial() {
    if (usernameTextEditingController.text.isNotEmpty) {
      initial = Utilities.getAvatarTitle(usernameTextEditingController.text);
    }
    setState(() {});
  }
}
