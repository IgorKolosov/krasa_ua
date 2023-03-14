import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:krasaua/remote/Key.dart';
import 'package:krasaua/remote/LocationsDevice.dart';
import 'package:krasaua/remote/VersionURL.dart';
import 'package:krasaua/translation/Messages.dart';
import 'package:krasaua/util/Constants.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'MainAppView.dart';
import 'NoConnectivityAppView.dart';


class StartAppView extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
        title: 'Flutter Geolocation',
        translations: Messages(),
        locale: Get.deviceLocale,
        fallbackLocale: const Locale('uk', 'UA'),
        theme: ThemeData(
          primaryColor: const Color(0xFF5F5AC5),
        ),
        home: GetUserLocation(title: 'Flutter Geolocation'),

    );
  }
}

class GetUserLocation extends StatefulWidget {
  GetUserLocation({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _GetUserLocationState createState() => _GetUserLocationState();
}

class _GetUserLocationState extends State<GetUserLocation> {
  LocationData? currentLocation;
  String address = "";
  final myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                "assets/Krasaua.gif",
                height: 125.0,
                width: 125.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _checkConnectivity() {
    Route route;
    checkConnectivity().then((value) => {
      if (value)
        {_checkKey()}
      else
        {
          route =
              MaterialPageRoute(builder: (context) => NoConnectivityAppView()),
          Navigator.pushReplacement(context, route),
        }
    });
  }

  void _checkKey() {
    _loadData(Constants.KEY_KEY).then((key) => {
      if (key == '')
        {
          createRequestKey('').then((value) => {
            _savedData(Constants.KEY_KEY, value.key.toString(),
                value.ver_url.toString())
          }),
        }
      else
        {
          createRequestVersionUrl(key)
              .then((value) => {sendLocations(key, value)}),
        }
    });
  }

  //save data in local storage
  Future<void> _savedData(String key, String key_value, String vurl) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, key_value);

    sendLocations(key_value, vurl);
  }

  //check locations device and go to view
  void sendLocations(String key, String vurl){
    _getLocationData().then((value) => {
      if (value == null)
        {
          _startWebView(vurl),
        }
      else
        {
          sendYesLocationDevice(value.latitude!.toDouble(),
              value.longitude!.toDouble(), key)
              .then((value) => {
            _startWebView(vurl),
          })
        }
    });
  }

  //load data in local storage
  Future<String> _loadData(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final String _key = await prefs.getString(key) ?? '';
    return _key;
  }

  //permission GPS, get location device
  Future<LocationData?> _getLocationData() async {
    Location location = new Location();
    LocationData _locationData;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await location.getLocation();

    return _locationData;
  }

  //start activity webview
  void _startWebView(String url) {
    Route route = MaterialPageRoute(
        builder: (context) => MainAppView(
          url: url,
        ));
    Navigator.pushReplacement(context, route);

    //timer 5 sec
    /*Future.delayed(Duration(seconds: 5), () {
        //set method
    });*/
  }
}
