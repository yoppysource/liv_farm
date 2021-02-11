import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/model/coupon.dart';
import 'package:liv_farm/viewmodel/coupon_view_model.dart';
import 'package:provider/provider.dart';

class CouponWidget extends StatelessWidget with Formatter {
  final Coupon coupon;

  const CouponWidget({Key key, this.coupon}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CouponViewmodel _model = Provider.of<CouponViewmodel>(context, listen: true);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: this.coupon == _model.selectedCoupon ? Color(kSubColorRed) :Colors.black38, width: this.coupon == _model.selectedCoupon ? 1:  0.5)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coupon.description,
                  style: TextStyle(fontSize: 15, color: Colors.black87),
                ),
                Text(
                  coupon.type == 1
                      ? "${getPriceFromInt(coupon.value.toInt())} 할인"
                      : "${(coupon.value*100).toInt()}% 할인",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(kSubColorRed).withOpacity(0.9),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 10,
                ),
                Align(
                    alignment: Alignment.topRight,
                    child: Text(
                      "~${getStringFromDatetime(coupon.expireDate)}",
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ), Align(
            alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                child: GestureDetector(
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
                  onTap: () {
                   _model.selectCoupon(this.coupon);
                  },
                ),
              ))
        ],
      ),
    );
  }
}
