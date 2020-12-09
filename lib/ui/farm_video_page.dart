import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewExample extends StatefulWidget {
  //TODO: 그림 서버에 저장해주기.
  @override
  WebViewExampleState createState() => WebViewExampleState();
}

class WebViewExampleState extends State<WebViewExample> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SafeArea(
        child: Center(
          child: WebView(
            initialUrl: 'http://34.64.245.117:3000/admin/streaming',
            javascriptMode: JavascriptMode.unrestricted,
          ),
        ),
      ),
    );
  }
}