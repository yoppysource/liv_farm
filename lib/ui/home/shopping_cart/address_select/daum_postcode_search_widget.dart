
library daum_postcode_search;

import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter/material.dart';

class DaumPostcodeSearchWidget extends StatefulWidget {
  final String webPageTitle;
  final _DaumPostcodeSearchWidgetState _state = _DaumPostcodeSearchWidgetState();
  InAppWebViewController get controller => this._state._controller;

  DaumPostcodeSearchWidget({
    Key key,
    this.webPageTitle = "주소 검색",
  }) : super(key: key);

  @override
  _DaumPostcodeSearchWidgetState createState() => _state;
}

class _DaumPostcodeSearchWidgetState extends State<DaumPostcodeSearchWidget> {
  InAppLocalhostServer localhostServer = InAppLocalhostServer();

  InAppWebViewController _controller;
  InAppWebViewController get controller => _controller;
  int progress = 0;
  bool isServerRunning = false;

  @override
  void initState() {
    super.initState();
    localhostServer.start().then((_) {
      setState(
        () => isServerRunning = true,
      );
    });
  }

  @override
  void dispose() {
    localhostServer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result;
    if (isServerRunning) {
      result = InAppWebView(
        initialUrl: "http://localhost:8080/assets/daum_search.html",
        initialOptions: 
            InAppWebViewGroupOptions(
              crossPlatform: InAppWebViewOptions(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
              ),
              ios: IOSInAppWebViewOptions(
                allowsInlineMediaPlayback: true,
              ),
            ),
        androidOnPermissionRequest:
            (InAppWebViewController controller, String origin,
                List<String> resources) async {
              return PermissionRequestResponse(
                  resources: resources,
                  action: PermissionRequestResponseAction.GRANT);
            },
        onWebViewCreated: (InAppWebViewController webViewController) async {
          webViewController.addJavaScriptHandler(
              handlerName: 'onSelectAddress',
              callback: (args) {
                Navigator.of(context).pop(
                    args[0]
                );
              });

          this._controller = webViewController;
        },
      );
    } else {
      result = Center(
        child: CircularProgressIndicator(),
      );
    }

    return result;
  }
}
