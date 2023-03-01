import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:krasaua/util/Constants.dart';

Future<KeyModel> createRequestKey(String key) async {
  final response = await http.post(
    Uri.parse(Constants.MAIN_URL + 'key_g.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'key': key,
    }),
  );

  if (response.statusCode == 200) {
    return KeyModel.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to create album.');
  }
}

class KeyModel {
  final String key;
  final String ver_url;

  KeyModel({required this.key, required this.ver_url});

  factory KeyModel.fromJson(Map<String, dynamic> json) {
    return KeyModel(
      key: json['key'],
      ver_url: json['url'],
    );
  }
}
