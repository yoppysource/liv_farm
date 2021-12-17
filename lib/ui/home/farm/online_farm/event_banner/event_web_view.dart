import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EventWebView extends StatefulWidget {
  final String url;
  final String imageUrl;

  const EventWebView({Key key, this.url, this.imageUrl}) : super(key: key);

  @override
  EventWebViewState createState() => EventWebViewState();
}

class EventWebViewState extends State<EventWebView> {
  @override
  void initState() {
    super.initState();
    // Enable hybrid composition.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        fit: BoxFit.fitWidth,
        errorWidget: (context, url, error) => Icon(Icons.error),
        fadeInDuration: Duration(milliseconds: 50),
      ),
    );
  }
}
