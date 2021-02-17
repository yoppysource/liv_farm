import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/my_farm_page/components/address_information_card.dart';
import 'package:liv_farm/ui/my_farm_page/components/order_status_card.dart';
import 'package:liv_farm/ui/my_farm_page/coupon_page/coupon_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';
import 'package:liv_farm/ui/web_view_page/policy_page.dart';
import 'package:liv_farm/viewmodel/coupon_view_model.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:liv_farm/viewmodel/shopping_cart_view_model.dart';
import 'package:provider/provider.dart';

import 'components/user_information_card.dart';

class MyFarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    LandingPageViewModel _model = Provider.of<LandingPageViewModel>(context,listen: false);
    log.builderLog(className: 'MyFarmPage Builder called');
    final fullWidth = MediaQuery.of(context).size.width;
    return  Scaffold(
      appBar: MyAppBar(title: '마이 팜'),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: fullWidth,
            child: Column(
              children: [
                SizedBox(
                  height: 2,
                ),
                UserInformationCard(),
                OrderStatusCard(),
                AddressInformationCard(),
                MyCard(
                    child: Column(
                  children: [
                    MyFarmTile(
                      text: '쿠폰함',
                      onPressed: ()async  {
                        Coupon coupon = await   Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                          create: (context) => CouponViewmodel(Provider.of<LandingPageViewModel>(context, listen: false).user.id),
                            child: CouponPage())));
                        if(coupon!=null)
                          Provider.of<ShoppingCartViewmodel>(context,listen: false).applyCoupon(coupon);
                      },
                    ),
                    MyFarmTile(
                      text: '고객센터',
                      onPressed: () async{
                        await PlatformAlertDialog(title: '고객 센터', widget: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 20),
                          child: Text('대표: 010-3338-8197(강길모)'),
                        ),defaultActionText: '확인',).show(context);
                      },
                    ),
                    MyFarmTile(
                      text: '개인정보약관',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => PolicyPage()));
                      },
                    ),
                    MyFarmTile(
                      text: 'License',
                      onPressed: ()
                      {
                        showLicensePage(
                          context: context,
                          applicationIcon: Container(
                            height: 100,
                              width: 100,
                              child: Image.asset('assets/images/symbol.png')),
                          applicationName: "Liv Farm",
                          applicationLegalese:'COPYRIGHTⓒ 2021. Future Connect all rights reserved'
                        );

                      },
                    ),
                     MyFarmTile(
                        text: '로그아웃',
                        onPressed: () async {
                          await Provider.of<LandingPageViewModel>(context,
                                  listen: false)
                              .logout();
                        }),

                  ],
                ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MyFarmTile extends StatelessWidget {
  final String text;
  final Function onPressed;

  const MyFarmTile({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onPressed,
      leading: Padding(
        padding: const EdgeInsets.only(left: 5),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyText2.copyWith(color: Colors.black87),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    );
  }
}
