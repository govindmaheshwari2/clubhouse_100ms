import 'dart:ui';

import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';

class Utilities {
  static RegExp REGEX_EMOJI = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])');

  static String getAvatarTitle(String name) {
    if (name.contains(REGEX_EMOJI)) {
      name = name.replaceAll(REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return '😄';
      }
    }
    List<String>? parts = name.trim().split(" ");
    if (parts.length == 1) {
      name = parts[0][0];
    } else if (parts.length >= 2) {
      name = parts[0][0];
      if (parts[1] == "" || parts[1] == " ") {
        name += parts[0][1];
      } else {
        name += parts[1][0];
      }
    }
    return name.toUpperCase();
  }

  static void getPermissions() async {
    await Permission.microphone.request();

    while ((await Permission.microphone.isDenied)) {
      await Permission.microphone.request();
    }
  }

  static Color getBackgroundColour(String name) {
    if (name.isEmpty) return Colors.blue.shade600;
    if (name.contains(REGEX_EMOJI)) {
      name = name.replaceAll(REGEX_EMOJI, '');
      if (name.trim().isEmpty) {
        return Colors.blue.shade600;
      }
    }
    return Utilities
        .colors[name.toUpperCase().codeUnitAt(0) % Utilities.colors.length];
  }

  static List<Color> colors = [
    Colors.amber,
    Colors.blue.shade600,
    Colors.purple,
    Colors.lightGreen,
    Colors.redAccent
  ];

  static void showToast(String message,{int time = 1}){
    BotToast.showText(
        textStyle: GoogleFonts.inter(fontSize: 14),
        text: message,
        contentColor: Colors.black87,
        duration: Duration(seconds: time));
  }
}
