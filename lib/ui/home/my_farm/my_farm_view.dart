import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/ui/home/my_farm/my_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/my_farm/policy_page/policy_page.dart';
import 'package:liv_farm/ui/home/my_farm/user_information/user_information_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class MyFarmView extends StatelessWidget {
  const MyFarmView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyFarmViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: ListView(
            padding: horizontalPaddingToScaffold,
            children: [
              verticalSpaceMedium,
              UserInformationView(),
              verticalSpaceMedium,
              Column(
                children: [
                  MyFarmTile(
                    text: '쿠폰함',
                    onPressed: () {},
                  ),
                  verticalSpaceTiny,
                  MyFarmTile(
                    text: '배송지 설정',
                    onPressed: model.onPressedAddressSelect,
                  ),
                  verticalSpaceTiny,
                  MyFarmTile(
                    text: '고객센터',
                    onPressed: model.onTapCustomerService,
                  ),
                  verticalSpaceTiny,
                  MyFarmTile(
                    text: '개인정보약관',
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PolicyPage()));
                    },
                  ),
                  verticalSpaceTiny,
                  MyFarmTile(
                    text: 'License',
                    onPressed: () {
                      showLicensePage(
                          context: context,
                          applicationIcon: Container(
                              height: 100,
                              width: 100,
                              child: Image.asset('assets/images/symbol.png')),
                          applicationName: "LivFarm",
                          applicationLegalese:
                              'COPYRIGHTⓒ 2021. Future Connect all rights reserved');
                    },
                  ),
                  verticalSpaceTiny,
                  MyFarmTile(
                      text: '로그아웃',
                      onPressed: () async {
                        await model.onTapLogout();
                      }),
                  verticalSpaceTiny,
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => MyFarmViewModel(),
    );
  }
}

class MyFarmTile extends StatelessWidget {
  final String text;
  final Function onPressed;

  const MyFarmTile({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Center(
              child: Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: Colors.black87),
              ),
            ),
            Center(
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: kMainPink,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
