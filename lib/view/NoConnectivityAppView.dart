import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/utils.dart';
import 'StartAppView.dart';


Future<bool> checkConnectivity() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

class NoConnectivityAppView extends StatefulWidget {
  @override
  _NoConnectivityAppViewState createState() => _NoConnectivityAppViewState();
}

class _NoConnectivityAppViewState extends State<NoConnectivityAppView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/nowifi.png",
              height: 256.0,
              width: 256.0,
            ),
            const SizedBox(height: 32.0),
            Text(
              'error'.tr,
              style: const TextStyle(fontSize: 30.0, color: Colors.black),
            ),
            const SizedBox(height: 8.0),
            Text('noInternetConnection'.tr,
                style: const TextStyle(fontSize: 20.0, color: Colors.black)),
            const SizedBox(height: 32.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5F5AC5)),
              onPressed: () {
                Route route = MaterialPageRoute(builder: (context) => StartAppView());
                Navigator.pushReplacement(context, route);
              },
              child: Text("tryAgain".tr),
            )
          ],
        ),
      ),
    );
  }
}
