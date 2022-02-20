import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/events.dart';
import 'package:liv_farm/secret.dart';
import 'package:liv_farm/ui/home/home_main/event_banner/event_banner_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

import 'event_web_view.dart';

class EventBannerView extends StatelessWidget {
  const EventBannerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);
    return ViewModelBuilder<EventBannerViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      viewModelBuilder: () => locator<EventBannerViewModel>(),
      builder: (context, model, child) => model.eventsList == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : LayoutBuilder(builder: (context, constraint) {
              return Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      model.setPageIndex(index);
                    },
                    scrollDirection: Axis.horizontal,
                    children: model.eventsList!.map((Event event) {
                      return GestureDetector(
                        child: CachedNetworkImage(
                          imageUrl: "${Uri(
                            scheme: scheme,
                            host: hostIP,
                            port: hostPORT,
                          ).toString()}${event.imageUrl}",
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          fadeInDuration: const Duration(milliseconds: 50),
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                settings: const RouteSettings(
                                    name: '/event-detail-view'),
                                builder: (context) => EventWebView(
                                  url: event.url,
                                  imageUrl: "${Uri(
                                    scheme: scheme,
                                    host: hostIP,
                                    port: hostPORT,
                                  ).toString()}${event.imageUrl}",
                                ),
                              ));
                        },
                      );
                    }).toList(),
                  ),
                  Positioned(
                    top: constraint.maxHeight * 100 / 45 * 0.34,
                    right: 25,
                    child: Theme(
                      data: ThemeData(canvasColor: Colors.transparent),
                      child: Chip(
                        visualDensity:
                            const VisualDensity(horizontal: 0.0, vertical: -4),
                        backgroundColor: kMainGrey.withOpacity(0.6),
                        elevation: 0.0,
                        label: Text(
                          '${model.pageIndex + 1} / ${model.eventsList!.length}',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText2!
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }),
    );
  }
}
