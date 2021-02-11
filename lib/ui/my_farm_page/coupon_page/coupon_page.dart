import 'package:flutter/material.dart';
import 'package:liv_farm/ui/my_farm_page/coupon_page/coupon_widget.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/viewmodel/coupon_view_model.dart';
import 'package:provider/provider.dart';

class CouponPage extends StatefulWidget {
  @override
  _CouponPageState createState() => _CouponPageState();
}

class _CouponPageState extends State<CouponPage> {
  TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CouponViewmodel _model = Provider.of<CouponViewmodel>(context, listen: true);
    return Stack(
      children: [
        Scaffold(
          appBar: MyAppBar(),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyCard(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  TitleText(
                    text: '쿠폰등록',
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: PlatformTextField(
                            controller: _controller,
                            hintText: '쿠폰번호를 입력해 주세요',
                          ),
                        ),
                      ),
                      Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: OutlineButton(
                              child: Text(
                                '등록',
                                style: TextStyle(color: Colors.black54),
                              ),
                              onPressed:(){print('ds');},
                              shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(width: 0.5, style: BorderStyle.solid),
                                  borderRadius: BorderRadius.circular(5)),
                              highlightedBorderColor: Colors.red,
                              disabledBorderColor: Colors.black.withOpacity(0.2),
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                ],
              ),),
              MyCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 15,
                    ),
                    TitleText(
                      text: '쿠폰함',
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
        children:  _model.couponList.map((e) => CouponWidget(coupon: e)).toList(),
        ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        if(_model.selectedCoupon != null)
          BottomFloatButton(text: '쿠폰 사용하기', onPressed: () {
            Navigator.pop(context, _model.selectedCoupon);
          },)
      ],
    );
  }
}
