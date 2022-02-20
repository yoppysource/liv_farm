import 'package:flutter/material.dart';
import 'package:liv_farm/model/store.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class StoreCard extends StatelessWidget {
  const StoreCard({
    Key? key,
    required this.store,
    this.radius = 20.0,
  }) : super(key: key);
  final Store store;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(radius),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(1.0, 1.0),
                    blurRadius: 1.0,
                    spreadRadius: 1.0,
                  )
                ]),
          ),
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(radius)),
            child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 12,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              store.name,
                              style: theme.subtitle2!
                                  .copyWith(fontWeight: FontWeight.normal),
                            ),
                            Row(
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  color: store.takeOut
                                      ? kDelightPink
                                      : Colors.black12,
                                ),
                                horizontalSpaceTiny,
                                Icon(
                                  Icons.delivery_dining_outlined,
                                  color: store.delivery
                                      ? kDelightPink
                                      : Colors.black38,
                                )
                              ],
                            )
                          ],
                        ),
                        Column(
                          children: [
                            TextRowWithTitle(
                              title: '위치',
                              content: store.address,
                            ),
                            verticalSpaceTiny,
                            TextRowWithTitle(
                              title: '운영시간',
                              content:
                                  "${store.openHourStr} ~ ${store.closeHourStr}",
                            ),
                            verticalSpaceTiny,
                            TextRowWithTitle(
                              title: '휴일',
                              content: store.getHolidaysInString(),
                            ),
                            verticalSpaceTiny,
                            if (store.distance != null)
                              TextRowWithTitle(
                                title: '거리',
                                content: store.getDistanceString()!,
                              ),
                            // Row(
                            //   children: [
                            //     Text(store.openHourStr),
                            //     const Text(' ~ '),
                            //     Text(store.closeHourStr),
                            //   ],
                            // ),
                            // verticalSpaceTiny,
                            // Text(
                            //   store.getHolidaysInString(),
                            //   textAlign: TextAlign.left,
                            // ),
                            // verticalSpaceTiny,
                            // if (store.distance != null)
                            //   Text(store.getDistanceString()!)
                          ],
                        )
                      ],
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class TextRowWithTitle extends StatelessWidget {
  const TextRowWithTitle({
    Key? key,
    required this.title,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.bodyText2!.copyWith(color: Colors.black87),
        ),
        horizontalSpaceSmall,
        Expanded(
          child: Text(
            content,
            style: theme.bodyText2,
          ),
        ),
      ],
    );
  }
}
