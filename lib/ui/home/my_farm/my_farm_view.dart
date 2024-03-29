import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/my_farm/my_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/my_farm/policy_page/policy_page.dart';
import 'package:liv_farm/ui/home/my_farm/user_information/user_information_view.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:stacked/stacked.dart';

class MyFarmView extends StatelessWidget {
  const MyFarmView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MyFarmViewModel>.reactive(
      builder: (context, model, child) => SafeArea(
        child: LoadingOverlay(
          isLoading: model.isBusy,
          color: Colors.black38,
          child: Scaffold(
            body: ListView(
              padding: horizontalPaddingToScaffold,
              children: [
                verticalSpaceRegular,
                const UserInformationView(),
                verticalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    children: [
                      MyFarmTile(
                        text: '쿠폰함',
                        onPressed: () async {
                          await model.onPressedCouponSelect();
                        },
                      ),
                      verticalSpaceTiny,
                      MyFarmTile(
                        text: '배송지 설정',
                        onPressed: model.onPressedAddressSelect,
                      ),
                      verticalSpaceTiny,
                      MyFarmTile(
                        text: '비밀번호 변경',
                        onPressed: model.onPressChangePassword,
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
                                  builder: (context) => const PolicyPage()));
                        },
                      ),
                      verticalSpaceTiny,
                      MyFarmTile(
                        text: 'License',
                        onPressed: () {
                          showLicensePage(
                              context: context,
                              applicationIcon: SizedBox(
                                  height: 100,
                                  width: 100,
                                  child:
                                      Image.asset('assets/images/symbol.png')),
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
                      verticalSpaceRegular,
                    ],
                  ),
                ),
              ],
            ),
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

  const MyFarmTile({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: SizedBox(
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
                    .bodyText1!
                    .copyWith(color: Colors.black87),
              ),
            ),
            const Center(
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
