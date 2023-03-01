import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'NoConnectivityAppView.dart';

String kNavigationExamplePage = '''

<!DOCTYPE html><html>
<head><title>Navigation Delegate Example</title></head>
<body>
<p>
The navigation delegate is set to block navigation to the youtube website.
</p>
<ul>
<ul><a href="https://www.youtube.com/">https://www.youtube.com/</a></ul>
<ul><a href="https://www.google.com/">https://www.google.com/</a></ul>
</ul>
</body>
</html>
''';

class MainAppView extends StatefulWidget {
  final String url;

  MainAppView({required this.url});

  @override
  _MainAppViewState createState() => _MainAppViewState(url: url);
}

class _MainAppViewState extends State<MainAppView> {
  WebViewController? _controller;

  final Completer<WebViewController> _controllerCompleter =
  Completer<WebViewController>();

  final String url;

  _MainAppViewState({required this.url});

  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid)  WebView.platform = SurfaceAndroidWebView();

    //check internet connectivity
    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      MaterialPageRoute route;
      checkConnectivity().then((value) => {
        if (!value)
          {
            route = MaterialPageRoute(
                builder: (context) => NoConnectivityAppView()),
            Navigator.pushReplacement(context, route),
          }
      });
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return Center(
            child: Padding(
              padding: EdgeInsets.only(top: 26.0),
              child: WebView(
                initialUrl: url,
                javascriptMode: JavascriptMode.unrestricted,
                onWebViewCreated: (WebViewController webViewController) {
                  _controllerCompleter.future
                      .then((value) => _controller = value);
                  _controllerCompleter.complete(webViewController);
                },
                onProgress: (int progress) {
                  print("WebView is loading (progress : $progress%)");
                },
                javascriptChannels: <JavascriptChannel>{
                  _toasterJavascriptChannel(context),
                },
                navigationDelegate: (NavigationRequest request) {
                  if (request.url.startsWith('https://www.youtube.com/')) {
                    print('blocking navigation to $request}');
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("mailto:")) {
                    launch(request.url);
                    return NavigationDecision.prevent;
                  } else if (request.url.contains("tel:")) {
                    launch(request.url);
                    return NavigationDecision.prevent;
                  }
                  print('allowing navigation to $request');
                  return NavigationDecision.navigate;
                },
                onPageStarted: (String url) {
                  print('Page started loading: $url');
                },
                onPageFinished: (String url) {
                  print('Page finished loading: $url');
                },
                gestureNavigationEnabled: true,
              ),
            ),
          );
        }),
      ),
    );
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }

  Future<bool> _goBack(BuildContext context) async {
    if (await _controller!.canGoBack()) {
      _controller!.goBack();
      return Future.value(false);
    } else {
      SystemNavigator.pop();
      // диалог => [Хотите выйти с приложение / да / нет]
      /*    showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Do you want to exit'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('No'),
              ),
              FlatButton(
                onPressed: () {

                },
                child: Text('Yes'),
              ),
            ],
          ));*/
      return Future.value(true);
    }
  }
}
