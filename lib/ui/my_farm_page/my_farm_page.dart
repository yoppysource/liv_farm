import 'package:flutter/material.dart';
import 'package:liv_farm/temp/logger.dart';
import 'package:liv_farm/ui/my_farm_page/components/address_information_card.dart';
import 'package:liv_farm/ui/my_farm_page/components/order_status_card.dart';
import 'package:liv_farm/ui/online_shopping_page/my_drawer.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'components/user_information_card.dart';

class MyFarmPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    log.builderLog(className: 'MyFarmPage Builder called');
    final fullWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      drawer: MyDrawer(),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
