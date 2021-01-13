import 'package:flutter/material.dart';
import 'package:liv_farm/ui/my_farm_page/detailed_purchase_log_page.dart';
import 'package:liv_farm/ui/shared/buttons/refresh_button.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/viewmodel/detailed_purchase_view_model.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/online_shopping_view_model.dart';
import 'package:provider/provider.dart';

import 'order_status_count.dart';

class OrderStatusCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final MyFarmPageViewModel _model =
    Provider.of<MyFarmPageViewModel>(context, listen: true);
    return MyCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  TitleText(text: '주문/배송조회'),
                  RefreshButton(
                    iconSize: 23,
                    onPressed: () async {
                    await _model.init();
                  },)
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '더 보기',
                        style: TextStyle(fontSize: 15, color: Colors.black54),
                      ),
                      Icon(Icons.arrow_forward_ios_outlined,
                          size: 13, color: Colors.black54),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider(
                        create: (context) => DetailedPurchaseViewmodel(
                            _model.purchaseList,
                            Provider.of<OnlineShoppingViewmodel>(context,
                                listen: false)
                                .productList),
                        child: DetailedPurchaseLogPage(),
                      ),
                      fullscreenDialog: true,
                    ));
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          _model?.orderCountList == null
              ? Center(child: CircularProgressIndicator())
              : OrderStatusCount(
            numberList: _model.orderCountList,
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}