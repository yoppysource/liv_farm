import 'package:flutter/material.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/ui/shared/formatter.dart';
import 'package:liv_farm/ui/shared/styles.dart';

class CouponWidget extends StatelessWidget with Formatter {
  final Coupon coupon;
  final bool selected;

  const CouponWidget({Key key, this.coupon, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: selected ? kSubColor : Colors.black38,
                  width: selected ? 1 : 0.5)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    coupon.description ?? "할인쿠폰",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  GestureDetector(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '선택하기',
                          style: TextStyle(fontSize: 15, color: Colors.black54),
                        ),
                        Icon(Icons.arrow_forward_ios_outlined,
                            size: 13, color: Colors.black54),
                      ],
                    ),
                    onTap: () {},
                  )
                ],
              ),
              verticalSpaceSmall,
              Text(
                coupon.category == "value"
                    ? "${getPriceFromInt(coupon.amount.toInt())} 할인"
                    : "${(coupon.amount * 100).toInt()}% 할인",
                style: TextStyle(
                    fontSize: 20,
                    color: kSubColor,
                    fontWeight: FontWeight.w700),
              ),
              verticalSpaceSmall,
              Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    "~${getStringFromDatetime(coupon.expireDate)}",
                    textAlign: TextAlign.right,
                  )),
            ],
          ),
        ),
        verticalSpaceRegular,
      ],
    );
  }
}
