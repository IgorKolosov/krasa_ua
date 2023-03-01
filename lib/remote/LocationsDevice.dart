import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:krasaua/util/Constants.dart';

Future<bool> sendYesLocationDevice(double lat, double lon, String key) async {
  final response = await http.post(
    Uri.parse(Constants.MAIN_URL + 'geo.php'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'lon': lon.toString(),
      'lat': lat.toString(),
      'key': key,
    }),
  );

  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}
