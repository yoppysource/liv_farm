import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/home/farm/online_farm/event_banner/event_banner_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

import 'event_web_view.dart';

class EventBannerView extends StatelessWidget {
 const EventBannerView({Key key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<EventBannerViewModel>.reactive(
     builder: (context, model, child) => model.eventsDataList==null ? Center(child: CircularProgressIndicator(),):ImageSlideshow(
      /// Shows the tab indicating circles at the bottom
      autoPlayInterval: 3000,
      height: 200,
      initialPage: 0,
      indicatorColor: kMainPink,
          indicatorBackgroundColor: Colors.grey,
      width: MediaQuery.of(context).size.width - 20,
      children: model.eventsDataList.map((dynamic data) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  settings: RouteSettings(name: '/event-detail-view'),
                  builder: (context) => EventWebView(
                    url: data['url'],
                    imageUrl: "${Uri(
                      scheme: scheme,
                      host: hostIP,
                      port: hostPORT,
                    ).toString()}${data["imageUrl"]}",
                  ),
                ));
          },
          child: new ClipRRect(
            borderRadius: BorderRadius.circular(5.0),
            child: CachedNetworkImage(
              imageUrl: "${Uri(
                scheme: scheme,
                host: hostIP,
                port: hostPORT,
              ).toString()}${data["imageUrl"]}",
              fit: BoxFit.fitWidth,
              errorWidget: (context, url, error) => Icon(Icons.error),
              fadeInDuration: Duration(milliseconds: 50),
            ),
          ),
        );
      }).toList(),
    ),
     viewModelBuilder: () => EventBannerViewModel(),
   );
 }
}