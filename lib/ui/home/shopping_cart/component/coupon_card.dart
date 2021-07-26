import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class CouponCard extends StatelessWidget {
  final ShoppingCartViewModel model;

  const CouponCard({Key key, this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyCard(
          title: '쿠폰/포인트 사용',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('쿠폰', style: Theme.of(context).textTheme.bodyText1,),
              verticalSpaceTiny,
              Container(
                height: 60,
                decoration: BoxDecoration(
                    color: kMainColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black38, width: 0.2)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              model.selectedCoupon == null
                                  ? '쿠폰을 선택해주세요'
                                  : model.selectedCoupon.description ?? "할인쿠폰",
                              style: TextStyle(fontSize: 14, color: kMainGrey),
                            ),
                          ),
                        ),
                      ),
                      horizontalSpaceSmall,
                      FlatButton(
                          color: Colors.white,
                          child: Text(
                            '선택',
                            style: TextStyle(color: kMainBlack),
                          ),
                          onPressed: model.onPressedCouponSelect,
                          shape: RoundedRectangleBorder(
                              side: BorderSide(
                                  color: kMainGrey,
                                  width: 0.3,
                                  style: BorderStyle.solid),
                              borderRadius: BorderRadius.circular(5))),
                    ],
                  ),
                ),
              ),
              verticalSpaceTiny,
              model.isCouponAmountExceedDiscountedPrice
                  ? Text(
                      "결제 금액이 쿠폰할인 금액보다 더 커야합니다.",
                      style: Theme.of(context)
                          .textTheme
                          .bodyText2
                          .copyWith(color: Colors.red),
                    )
                  : Container(),
              verticalSpaceSmall,
              Text('포인트', style: Theme.of(context).textTheme.bodyText1,),
              verticalSpaceTiny,
          Container(
            height: 60,
            decoration: BoxDecoration(
                color: kMainPink.withOpacity(0.5),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black38, width: 0.2)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          model.pointInput == 0
                              ? '사용 가능한 포인트: ${model.availablePoint}점'
                              : "${model.pointInput}점 적용",
                          style: TextStyle(fontSize: 14, color: kMainGrey),
                        ),
                      ),
                    ),
                  ),
                  horizontalSpaceSmall,
                  FlatButton(
                      color: Colors.white,
                      child: Text(
                        '입력',
                        style: TextStyle(color: kMainBlack),
                      ),
                      onPressed: model.onPressPointInput,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: kMainGrey,
                              width: 0.3,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(5))),
                ],
              ),
            ),
          ),
          verticalSpaceTiny,
          model.isInputPointAmountExceedDiscountedPrice
              ? Text(
                  "상품 금액이 할인 금액보다 더 커야합니다.",
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.red),
                )
              : Container()
            ],
          ),
        ),
      ],
    );
  }
}
