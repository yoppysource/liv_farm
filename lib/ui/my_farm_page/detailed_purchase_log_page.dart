import 'package:flutter/material.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/viewmodel/detailed_purchase_view_model.dart';
import 'package:provider/provider.dart';

class DetailedPurchaseLogPage extends StatelessWidget with Formatter {
  final Map<int, String> purchaseStatusToString = {
    0: '결제완료',
    1: '포장 중',
    2: '배송 중',
    3: '전달 완료',
    4: '환불 처리',
  };

  @override
  Widget build(BuildContext context) {
    DetailedPurchaseViewmodel _model =
        Provider.of<DetailedPurchaseViewmodel>(context, listen: true);
    return Scaffold(
      appBar: MyAppBar(
        title: '상세 주문 내역',
      ),
      body: (_model.isBusy)
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _model.purchasePairedWithProductList.length,
                  itemBuilder: (context, index) {
                    Purchase purchase = _model
                        .purchasePairedWithProductList.keys
                        .elementAt(index);
                    return MyCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${getStringFromDateTimeInString(purchase.orderTimestamp)}',
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w700),
                            ),
                            Center(
                              child: Container(
                                child: Text(
                                  '   ${this.purchaseStatusToString[purchase.purchaseStatus]}',
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.8),
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.5),
                                ),
                                color: Colors.grey.withOpacity(0.25),
                                height:
                                    MediaQuery.of(context).size.height * 0.028,
                                width: MediaQuery.of(context).size.width * 0.9,
                              ),
                            ),
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Product product =
                                      _model.purchasePairedWithProductList[
                                          purchase][index];
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Image.network(
                                              product.imagePath,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(product.name,
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black87,
                                                      letterSpacing: 0.7)),

                                              Text(
                                                  '구매수량 | ${product.quantity.toString()}개'),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                  getPriceFromInt(
                                                      product.price),
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: Colors.black87,
                                                      letterSpacing: 0.7)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 0.3,
                                              color: Colors.black54),
                                        ),
                                        width: 130,
                                        height: 35,
                                        child: GestureDetector(
                                          child: Center(child: Text('재구매')),
                                          //TODO: 재주문 구현하기.
                                          onTap: () {},
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: _model
                                    .purchasePairedWithProductList[purchase]
                                    .length),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
