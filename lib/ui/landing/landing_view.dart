import 'package:flutter/material.dart';
import 'package:liv_farm/ui/landing/landing_viewmodel.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

//The role of landing page
//First, it should check the version information for the server
//Second, Check JWT token to determine whether the path should be homeView or promotionVideo
//
class LandingView extends StatelessWidget {
  const LandingView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LandingViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: Image.asset(
              "assets/images/livLogo.png",
              color: kSubColor,
            ),
          ),
        ),
      ),
      viewModelBuilder: () => LandingViewModel(),
    );
  }
}
