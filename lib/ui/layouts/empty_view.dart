import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class EmptyView extends StatelessWidget {
  final IconData iconData;
  final String text;

  const EmptyView({Key key, this.iconData, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            verticalSpaceMassive,
            Icon(
              iconData,
              color: kMainGrey,
              size: 80,
            ),
            verticalSpaceMedium,
            Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .subtitle2
                    .copyWith(color: kMainGrey, fontWeight: FontWeight.normal),
              ),
            )
          ],
        ),
      ),
    );
  }
}
