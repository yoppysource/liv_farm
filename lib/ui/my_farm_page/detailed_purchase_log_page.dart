import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/model/purchase.dart';
import 'package:liv_farm/model/purchased_product.dart';
import 'package:liv_farm/ui/my_farm_page/write_review_bottom_sheet.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/viewmodel/detailed_purchase_view_model.dart';
import 'package:liv_farm/viewmodel/product_description_view_model.dart';
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
          : _model.purchasedProductList.isEmpty ? Center(child: Text('주문 내역이 없습니다'),) : SingleChildScrollView(
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _model.purchasedProductList.length,
                  itemBuilder: (context, index) {
                    print(_model.purchasedProductList.length);
                    PurchasedProduct purchasedProduct = _model.purchasedProductList[index];
                    return MyCard(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                        purchasedProduct.orderTimestamp==null? '':
                              '${getStringFromDateTimeInString(purchasedProduct.orderTimestamp)}',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black.withOpacity(0.7),
                                  fontWeight: FontWeight.w700),
                            ),
                            Text(
                              '${PurchasedProduct.purchasedStatusMap[purchasedProduct.purchasedStatus]}',
                              style: TextStyle(
                                  color: Color(kSubColorRed),
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                ),
                            ),
                            ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  Product product = _model.productList.firstWhere((element) => element.id == purchasedProduct.productId);
                                  return Column(
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            height: 120,
                                            width: 120,
                                            child: Image(image: CachedNetworkImageProvider(product.thumbnailPath),)
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
                                              Text(product.productName,
                                                  style: Theme.of(context).textTheme.bodyText1),
                                              Text(
                                                  '구매수량 | ${purchasedProduct.quantity}개', style: Theme.of(context).textTheme.bodyText2,),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              Text(
                                                  getPriceFromInt(
                                                      product.productPrice),
                                                  style: Theme.of(context).textTheme.bodyText1.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
                                            ],
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.4,
                                                    color: Colors.black.withOpacity(0.8)),
                                              ),
                                              width: 130,
                                              height: 35,
                                              child:
                                                  Center(child: Text('리뷰 작성', style: Theme.of(context).textTheme.bodyText2,)),
                                            ),
                                            onTap: () {
                                              showModalBottomSheet(
                                                context: context,
                                                builder: (context) =>
                                                    ReviewWriteBottomSheet(
                                                  productId: product.id,
                                                ),
                                              );
                                            },
                                          ),
                                          GestureDetector(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0.4,
                                                    color:  Colors.black.withOpacity(0.8)),
                                              ),
                                              width: 130,
                                              height: 35,
                                              child: Center(child: Text('재구매', style: Theme.of(context).textTheme.bodyText2,)),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChangeNotifierProvider(
                                                              create: (context) =>
                                                                  ProductDescriptionViewmodel(
                                                                    product:
                                                                        product,
                                                                  ),
                                                              child:
                                                                  ProductDescriptionPage())));
                                            },
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                    ],
                                  );
                                },
                                separatorBuilder: (context, index) =>
                                    Container(),
                                itemCount: 1),
                          ],
                        ),
                      ),
                    );
                  }),
            ),
    );
  }
}
