import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class MyCard extends StatelessWidget {
  final String title;
  final Widget child;

  const MyCard({Key key, this.title, this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Card(
        elevation: 0,
        child: Padding(
          padding: horizontalPaddingToScaffold,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              verticalSpaceRegular,
              Text(
                title,
                style: Theme.of(context).textTheme.subtitle2,
              ),
              verticalSpaceRegular,
              child,
              verticalSpaceRegular,
              verticalSpaceRegular,
            ],
          ),
        ),
      ),
    );
  }
}
