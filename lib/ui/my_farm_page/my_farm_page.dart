import 'package:flutter/material.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/my_farm_page/components/address_information_card.dart';
import 'package:liv_farm/ui/my_farm_page/components/order_status_card.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/viewmodel/landing_page_view_model.dart';
import 'package:provider/provider.dart';
import 'components/user_information_card.dart';

class MyFarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.builderLog(className: 'MyFarmPage Builder called');
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
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
                      text: '고객센터',
                      onPressed: () {},
                    ),
                    MyFarmTile(
                      text: '개인정보약관',
                      onPressed: () {},
                    ),
                    MyFarmTile(
                      text: 'License',
                      onPressed: () {},
                    ),
                    MyFarmTile(
                        text: '로그아웃',
                        onPressed: () async {
                          await Provider.of<LandingPageViewModel>(context,
                                  listen: false)
                              .logout();
                        }),
                  ],
                )),
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
        padding: const EdgeInsets.only(left: 1),
        child: Text(
          text,
          style: TextStyle(color: Color(0xff153732)),
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    );
  }
}
