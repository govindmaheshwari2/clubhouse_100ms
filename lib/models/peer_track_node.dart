import 'package:hmssdk_flutter/hmssdk_flutter.dart';

class PeerTrackNode {
  String uid;
  HMSPeer peer;
  bool isRaiseHand;
  HMSTrack? audioTrack;
  PeerTrackNode(
      {required this.uid,required this.peer, this.audioTrack, this.isRaiseHand = false});

  @override
  String toString() {
    return 'PeerTracKNode{uid: $uid, peerId: ${peer.peerId},track: $audioTrack}';
  }
}
