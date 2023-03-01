import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:krasaua/util/Constants.dart';

Future<String> createRequestVersionUrl(String key) async {
  final response = await http.post(
    Uri.parse(Constants.MAIN_URL + 'get_url.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      '': '',
    }),
  );

  if (response.statusCode == 200) {
    return response.body.toString().replaceAll("%KEY%", key);
  } else {
    throw Exception('Failed to create album.');
  }
}


