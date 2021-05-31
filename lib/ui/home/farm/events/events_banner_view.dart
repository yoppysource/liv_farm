import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_slider/image_slider.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/home/farm/events/event_web_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class EventsBannerView extends StatefulWidget {
  final List eventsList;

  const EventsBannerView({Key key, this.eventsList}) : super(key: key);
  @override
  _EventsBannerViewState createState() => _EventsBannerViewState();
}

class _EventsBannerViewState extends State<EventsBannerView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    _tabController =
        TabController(length: widget.eventsList.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ImageSlider(
      /// Shows the tab indicating circles at the bottom
      showTabIndicator: true,
      height: 200,

      /// Cutomize tab's colors
      tabIndicatorColor: kMainGrey,

      /// Customize selected tab's colors
      tabIndicatorSelectedColor: kSubColor.withOpacity(0.9),

      /// Height of the indicators from the bottom
      tabIndicatorHeight: 12,

      /// Size of the tab indicator circles
      tabIndicatorSize: 10,

      /// tabController for walkthrough or other implementations
      tabController: _tabController,

      /// Animation curves of sliding
      curve: Curves.fastOutSlowIn,

      /// Width of the slider
      width: MediaQuery.of(context).size.width - 20,

      /// Height of the slider

      /// If automatic sliding is required
      autoSlide: true,

      /// Time for automatic sliding
      duration: new Duration(seconds: 5),

      /// If manual sliding is required
      allowManualSlide: true,

      /// Children in slideView to slide
      children: widget.eventsList.map((dynamic data) {
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
    );
  }
}
