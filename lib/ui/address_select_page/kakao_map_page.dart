import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class KakaoMapPage extends StatelessWidget {

  Position currentPosition;

  Future<Position> getLatLong(BuildContext context) async{
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      currentPosition =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      return currentPosition;
    } else {
      LocationPermission tryGetPermission = await Geolocator.requestPermission();
      if(tryGetPermission == LocationPermission.whileInUse || tryGetPermission == LocationPermission.always){
        currentPosition =  await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
        return currentPosition;
      } else {
        Navigator.pop(context);
        return null;
      }
    }
  }

  WebViewController _controller;
  WebViewController get controller => _controller;


  @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: getLatLong(context),
      builder: (BuildContext context, AsyncSnapshot<Position> snap){
        if(!snap.hasData || snap.data.longitude == null) return Scaffold(body: Center(child: CircularProgressIndicator(),),);
        String _url = "${MY_URL}/kakao/${snap.data.latitude.toString()}/${snap.data.longitude.toString()}";
        return Scaffold(
          appBar: MyAppBar(),
          body: WebView(
              initialUrl: _url,
              javascriptMode: JavascriptMode.unrestricted,
              javascriptChannels: Set.from([
                JavascriptChannel(
                    name: 'jschannel',
                    onMessageReceived: (JavascriptMessage message) async {
                    Map<String, dynamic> data = json.decode(message.message) as Map;
                     Navigator.pop(context, data);
                    }),
              ]),
              onWebViewCreated: (WebViewController webViewController) async {
                _controller = webViewController;
              }
              ),
        );
      },
    );
  }
}
