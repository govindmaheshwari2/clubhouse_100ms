import 'package:hmssdk_flutter/hmssdk_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JoinService {
  static Future<HMSConfig?> getHMSConfig({required String userName,required String roomId,required String tokenEndpoint,required String role}) async {
    //Replace with your Room Id (Watch setup video here: https://www.youtube.com/watch?v=GJ94-BaszpQ&feature=youtu.be)


    //Use your own Token endpoint (Watch setup video here: https://www.youtube.com/watch?v=GJ94-BaszpQ&feature=youtu.be)
    Uri endPoint = Uri.parse(tokenEndpoint);
    http.Response response = await http.post(endPoint,
        body: {'user_id': "user", 'room_id': roomId, 'role': role});
    var body = json.decode(response.body);
    if (body == null || body['token'] == null) {
      return null;
    }

    //Creating the HMSConfig by passing authToken which we get from above http call and user name
    HMSConfig config = HMSConfig(authToken: body['token'], userName: userName);
    return config;
  }
}
