import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class AsyncPageLayout extends StatelessWidget {
  final FutureViewModel model;
  final String errorMessage;
  final Widget chlid;

  const AsyncPageLayout(
      {Key? key,
      required this.model,
      this.errorMessage = "오류가 발생했습니다.",
      required this.chlid})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (model.data == null) {
      return const Center(child: CircularProgressIndicator());
    } else if (model.hasError) {
      return Container(
        color: Colors.red,
        alignment: Alignment.center,
        child: Text(
          errorMessage,
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (model.isBusy) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return chlid;
    }
  }
}
