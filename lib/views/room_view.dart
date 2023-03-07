import 'dart:developer';

import 'package:clubhouse_clone/models/peer_track_node.dart';
import 'package:clubhouse_clone/services/token_service.dart';
import 'package:clubhouse_clone/services/utilities.dart';
import 'package:clubhouse_clone/views/chat_view.dart';
import 'package:flutter/material.dart';
import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class RoomView extends StatefulWidget {
  final String username;
  final String userRole;
  const RoomView({required this.userRole, required this.username, Key? key})
      : super(key: key);

  @override
  _RoomViewState createState() => _RoomViewState();
}

class _RoomViewState extends State<RoomView>
    implements HMSUpdateListener, HMSActionResultListener {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late HMSSDK _hmsSDK;
  List<PeerTrackNode> _listeners = [];
  List<PeerTrackNode> _speakers = [];
  List<HMSMessage> _messages = [];
  bool _isMicrophoneMuted = false;
  HMSPeer? _localPeer;
  @override
  void initState() {
    super.initState();
    initMeeting();
  }

  //This method initialises the room like joining the room and attaching listeners
  initMeeting() async {
    //This initialises the HMSSDK
    _hmsSDK = HMSSDK();

    //We build the hmsSDK by calling the build method ensure that the build method is an async call
    await _hmsSDK.build();

    //Attach the update listener to listen to room updates
    _hmsSDK.addUpdateListener(listener: this);

    //Calling the joinRoom method to join the room
    joinRoom(userName: widget.username, role: widget.userRole);
  }

  //We setup the join room functionality in this method like config creation etc.
  void joinRoom({required String role, required String userName}) async {
    String roomId = "6404d875cd8175701aac0551";
    String tokenEndpoint =
        "https://prod-in2.100ms.live/hmsapi/decoder.app.100ms.live/api/token";

    HMSConfig? roomConfig = await JoinService.getHMSConfig(
        userName: userName,
        roomId: roomId,
        tokenEndpoint: tokenEndpoint,
        role: role);

    if (roomConfig != null) {
      _hmsSDK.join(config: roomConfig);
    } else {
      Utilities.showToast(
          "Not able to join the room, roomId: $roomId, tokenEndpoint: $tokenEndpoint, roomConfig: $roomConfig",
          time: 10);
      Navigator.pop(context);
    }
  }

  ////This are the override methods of HMSUpdateListener to get the room updates
  @override
  void onAudioDeviceChanged(
      {HMSAudioDevice? currentAudioDevice,
      List<HMSAudioDevice>? availableAudioDevice}) {
    // TODO: implement onAudioDeviceChanged
  }

  @override
  void onChangeTrackStateRequest(
      {required HMSTrackChangeRequest hmsTrackChangeRequest}) {
    // TODO: implement onChangeTrackStateRequest
  }

  @override
  void onHMSError({required HMSException error}) {
    // TODO: implement onHMSError
  }

  @override
  void onJoin({required HMSRoom room}) {
    // TODO: implement onJoin
    room.peers?.forEach((peer) {
      if (peer.isLocal) {
        _localPeer = peer;
      }
    });
  }

  @override
  void onMessage({required HMSMessage message}) {
    _messages.add(message);
    setState(() {});
  }

  @override
  void onPeerUpdate({required HMSPeer peer, required HMSPeerUpdate update}) {
    // TODO: implement onPeerUpdate
    switch (update) {
      case HMSPeerUpdate.peerJoined:
        if (peer.isLocal) {
          _localPeer = peer;
        }
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == peer.peerId + "speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            } else {
              _speakers.add(PeerTrackNode(
                uid: peer.peerId + "speaker",
                peer: peer,
              ));
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == peer.peerId + "listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            } else {
              _listeners.add(
                  PeerTrackNode(uid: peer.peerId + "listener", peer: peer));
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.peerLeft:
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == peer.peerId + "speaker");
            if (index != -1) {
              _speakers.removeAt(index);
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == peer.peerId + "listener");
            if (index != -1) {
              _listeners.removeAt(index);
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.roleUpdated:
        if (peer.role.name == "speaker") {
          //This means previously the user must be a listener earlier in our case
          //So we remove the peer from listener and add it to speaker list
          int index = _listeners
              .indexWhere((node) => node.uid == peer.peerId + "listener");
          if (index != -1) {
            _listeners.removeAt(index);
          }
          _speakers.add(PeerTrackNode(
            uid: peer.peerId + "speaker",
            peer: peer,
          ));
          setState(() {});
        } else if (peer.role.name == "listener") {
          //This means previously the user must be a speaker earlier in our case
          //So we remove the peer from speaker and add it to listener list
          int index = _speakers
              .indexWhere((node) => node.uid == peer.peerId + "speaker");
          if (index != -1) {
            _speakers.removeAt(index);
          }
          _listeners.add(PeerTrackNode(
            uid: peer.peerId + "listener",
            peer: peer,
          ));
          setState(() {});
        }
        break;
      case HMSPeerUpdate.metadataChanged:
        // TODO: Handle this case.
        switch (peer.role.name) {
          case "speaker":
            int index = _speakers
                .indexWhere((node) => node.uid == peer.peerId + "speaker");
            if (index != -1) {
              _speakers[index].peer = peer;
            }
            setState(() {});
            break;
          case "listener":
            int index = _listeners
                .indexWhere((node) => node.uid == peer.peerId + "listener");
            if (index != -1) {
              _listeners[index].peer = peer;
            }
            setState(() {});
            break;
          default:
            //Handle the case if you have other roles in the room
            break;
        }
        break;
      case HMSPeerUpdate.nameChanged:
        // TODO: Handle this case.
        break;
      case HMSPeerUpdate.defaultUpdate:
        // TODO: Handle this case.
        break;
      case HMSPeerUpdate.networkQualityUpdated:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  void onReconnected() {
    // TODO: implement onReconnected
  }

  @override
  void onReconnecting() {
    // TODO: implement onReconnecting
  }

  @override
  void onRemovedFromRoom(
      {required HMSPeerRemovedFromPeer hmsPeerRemovedFromPeer}) {
    // TODO: implement onRemovedFromRoom
  }

  @override
  void onRoleChangeRequest({required HMSRoleChangeRequest roleChangeRequest}) {
    // TODO: implement onRoleChangeRequest
  }

  @override
  void onRoomUpdate({required HMSRoom room, required HMSRoomUpdate update}) {
    // TODO: implement onRoomUpdate
  }

  @override
  void onTrackUpdate(
      {required HMSTrack track,
      required HMSTrackUpdate trackUpdate,
      required HMSPeer peer}) {
    switch (peer.role.name) {
      case "speaker":
        int index =
            _speakers.indexWhere((node) => node.uid == peer.peerId + "speaker");
        if (index != -1) {
          _speakers[index].audioTrack = track;
        } else {
          _speakers.add(PeerTrackNode(
              uid: peer.peerId + "speaker", peer: peer, audioTrack: track));
        }
        setState(() {});
        break;
      case "listener":
        int index = _listeners
            .indexWhere((node) => node.uid == peer.peerId + "listener");
        if (index != -1) {
          _listeners[index].audioTrack = track;
        } else {
          _listeners.add(PeerTrackNode(
              uid: peer.peerId + "listener", peer: peer, audioTrack: track));
        }
        setState(() {});
        break;
      default:
        //Handle the case if you have other roles in the room
        break;
    }
  }

  @override
  void onUpdateSpeakers({required List<HMSSpeaker> updateSpeakers}) {
    // TODO: implement onUpdateSpeakers
  }

  /// These are the overrides on HMSActionResultListener to get the status of method calls i.e. whether it succeeded or failed

  @override
  void onSuccess(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        _hmsSDK.removeUpdateListener(listener: this);
        _hmsSDK.destroy();
        break;

      case HMSActionResultListenerMethod.sendBroadcastMessage:
        var message = HMSMessage(
            sender: _localPeer,
            message: arguments!['message'],
            type: arguments['type'],
            time: DateTime.now(),
            hmsMessageRecipient: HMSMessageRecipient(
                recipientPeer: null,
                recipientRoles: null,
                hmsMessageRecipientType: HMSMessageRecipientType.BROADCAST));
        _messages.add(message);
        setState(() {});
        break;
    }
  }

  @override
  void onException(
      {required HMSActionResultListenerMethod methodType,
      Map<String, dynamic>? arguments,
      required HMSException hmsException}) {
    switch (methodType) {
      case HMSActionResultListenerMethod.leave:
        log("Not able to leave error occured");
        break;
    }
  }

  /// ******************************************************************************************************************************************************

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _hmsSDK.leave(hmsActionResultListener: this);
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          leading: GestureDetector(
              onTap: () {
                _hmsSDK.leave(hmsActionResultListener: this);
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
              )),
        ),
        body: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade800,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(22), topRight: Radius.circular(22))),
          padding:
              const EdgeInsets.only(top: 30, left: 20, right: 20, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "100MS Room",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Divider(
                  height: 10,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Expanded(
                child: CustomScrollView(
                  slivers: [
                    const SliverToBoxAdapter(
                      child: Text(
                        "Speakers",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverGrid.builder(
                        itemCount: _speakers.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {},
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 25,
                                  child: Text(
                                    Utilities.getAvatarTitle(
                                        _speakers[index].peer.name),
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _speakers[index].peer.name,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, mainAxisSpacing: 5)),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Text(
                        "Listener",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: SizedBox(
                        height: 20,
                      ),
                    ),
                    SliverGrid.builder(
                        itemCount: _listeners.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onLongPress: () {},
                            child: Column(
                              children: [
                                Expanded(
                                  child: CircleAvatar(
                                    radius: 20,
                                    child: Text(
                                      Utilities.getAvatarTitle(
                                          _listeners[index].peer.name),
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  _listeners[index].peer.name,
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          );
                        },
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 5, crossAxisCount: 5)),
                  ],
                ),
              ),
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
                        _hmsSDK.leave(hmsActionResultListener: this);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '✌️ Leave quietly',
                        style: TextStyle(color: Colors.redAccent),
                      )),
                  const Spacer(),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder()),
                      onPressed: () {
                        _hmsSDK.toggleMicMuteState();
                        setState(() {
                          _isMicrophoneMuted = !_isMicrophoneMuted;
                        });
                      },
                      child:
                          Icon(_isMicrophoneMuted ? Icons.mic_off : Icons.mic)),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: EdgeInsets.zero,
                          shape: const CircleBorder()),
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.grey.shade900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            builder: ((context) => ChatView(
                                  messages: _messages,
                                  hmsSDK: _hmsSDK,
                                  listener: this,
                                )));
                      },
                      child: const Icon(Icons.chat))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
