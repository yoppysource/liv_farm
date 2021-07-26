import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class StreamingView extends StatefulWidget {
  final PageController pageController;
  static String streamingURL;

  const StreamingView({Key key, this.pageController}) : super(key: key);
  @override
  _StreamingViewState createState() => _StreamingViewState();
}

class _StreamingViewState extends State<StreamingView> {
  WebViewController _webViewController;
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebView(
          javascriptMode: JavascriptMode.unrestricted,
          initialUrl:
              "https://player.vimeo.com/video/576689583?badge=0&amp;autopause=0&amp;player_id=0&amp;app_id=58479",
          onWebViewCreated: (WebViewController webViewController) {
            _webViewController = webViewController;
            // _loadHtmlFromAssets();
          },
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: InkWell(
            onTap: () {
              widget.pageController.previousPage(
                  curve: Curves.easeIn, duration: Duration(milliseconds: 500));
            },
            child: Container(
              height: bottomBottomHeight,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: bottomButtonBorderRadius,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 1), // changes position of shadow
                  ),
                ],
              ),
              child: Padding(
                padding: horizontalPaddingToScaffold,
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          '다시 돌아가기',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      horizontalSpaceTiny,
                      Container(
                          child: Icon(
                        CupertinoIcons.arrow_up,
                        size: 18,
                        color: Color(0xff333333),
                      ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
