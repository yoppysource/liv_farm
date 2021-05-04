import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AsyncPageLayout extends StatelessWidget {
  final FutureViewModel model;
  final String errorMessage;
  final Widget chlid;

  const AsyncPageLayout(
      {Key key, this.model, this.errorMessage = "오류가 발생했습니다.", this.chlid})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (model?.data == null) {
      return Center(child: CircularProgressIndicator());
    } else if (model.hasError) {
      return Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Text(
          errorMessage,
          style: TextStyle(color: Colors.white),
        ),
      );
    } else if (model.isBusy) {
      return Center(child: CircularProgressIndicator());
    } else {
      return chlid;
    }
  }
}
