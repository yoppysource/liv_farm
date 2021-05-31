import 'package:flutter/material.dart';
import 'package:liv_farm/ui/home/coupon/coupon_viewmodel.dart';
import 'package:liv_farm/ui/home/coupon/coupon_widget.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';

class CouponView extends StatelessWidget {
  const CouponView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CouponViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: Stack(
          children: [
            SafeArea(
              child: ListView(
                padding: horizontalPaddingToScaffold,
                children: [
                  IconButton(
                    padding: EdgeInsets.zero,
                    alignment: Alignment.centerLeft,
                    icon: Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.black.withOpacity(0.75),
                      size: 32,
                    ),
                    onPressed: model.onBackPressed,
                  ),
                  verticalSpaceSmall,
                  MyCard(
                    title: "쿠폰 등록",
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                          color: kMainColor.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.black38, width: 0.2)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        child: GestureDetector(
                          onTap: () async {
                            await model.registerCoupon();
                          },
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
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        '쿠폰코드를 입력해주세요',
                                        style: TextStyle(
                                            fontSize: 14, color: kMainGrey),
                                      ),
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
                                  onPressed: () async {
                                    await model.registerCoupon();
                                  },
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
                    ),
                  ),
                  verticalSpaceSmall,
                  MyCard(
                    title: "쿠폰함",
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        model.couponList.isEmpty
                            ? SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: Center(
                                  child: Text('현재 등록하신 쿠폰이 없습니다'),
                                ),
                              )
                            : Container(
                                height:
                                    (MediaQuery.of(context).size.height * 0.8) -
                                        200,
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: model.couponList.length,
                                      itemBuilder: (context, index) {
                                        return GestureDetector(
                                            onTap: () =>
                                                model.selectCoupon(index),
                                            child: Container(
                                              child: CouponWidget(
                                                coupon: model.couponList[index],
                                                selected: model.selectedIndex ==
                                                    index,
                                              ),
                                            ));
                                      }),
                                ),
                              ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            if (model.selectedIndex != null)
              AnimatedAlign(
                duration: Duration(milliseconds: 10000),
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: model.onPressedApply,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 1,
                          offset: Offset(0, 1), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: kMainPink,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 1,
                            offset: Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Center(
                          child: Text(
                        "쿠폰 적용하기",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                        ),
                      )),
                    ),
                  ),
                ),
              )
          ],
        ),
      ),
      viewModelBuilder: () => CouponViewModel(),
    );
  }
}

// class CouponPage extends StatefulWidget {
//   @override
//   _CouponPageState createState() => _CouponPageState();
// }

// class _CouponPageState extends State<CouponPage> {
//   TextEditingController _controller = TextEditingController();

//   @override
//   void dispose() {
//     _controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     CouponViewmodel _model = Provider.of<CouponViewmodel>(context, listen: true);
//     return Stack(
//       children: [
//         Scaffold(
//           appBar: MyAppBar(),
//           body: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 MyCard(
//                     child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: 15,
//                     ),
//                     TitleText(
//                       text: '쿠폰등록',
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                     Row(
//                       children: [
//                         Expanded(
//                           flex: 2,
//                           child: Padding(
//                             padding: const EdgeInsets.symmetric(horizontal: 20),
//                             child: PlatformTextField(
//                               controller: _controller,
//                               hintText: '쿠폰번호를 입력해 주세요',
//                             ),
//                           ),
//                         ),
//                         Expanded(
//                             flex: 1,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(horizontal: 20),
//                               child: OutlineButton(
//                                 child: Text(
//                                   '등록',
//                                   style: TextStyle(color: Colors.black54),
//                                 ),
//                                 onPressed: ()async {
//                                   if(_controller.text == ''){
//                                     return;
//                                   }
//                                  bool result = await _model.registerCoupon(Provider.of<LandingPageViewModel>(context,listen: false).user.id, _controller.text);
//                                 _controller.text ='';
//                                  if(result){
//                                   ToastMessage().showCouponSuccessToast();
//                                   await _model.init(Provider.of<LandingPageViewModel>(context,listen: false).user.id);
//                                 } else{
//                                   ToastMessage().showCouponFailToast();
//                                 }
//                                  },
//                                 shape: RoundedRectangleBorder(
//                                     side:
//                                         BorderSide(width: 0.5, style: BorderStyle.solid),
//                                     borderRadius: BorderRadius.circular(5)),
//                                 highlightedBorderColor: Colors.red,
//                                 disabledBorderColor: Colors.black.withOpacity(0.2),
//                               ),
//                             )),
//                       ],
//                     ),
//                     SizedBox(
//                       height: 15,
//                     ),
//                   ],
//                 ),),
//                 MyCard(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         height: 15,
//                       ),
//                       TitleText(
//                         text: '쿠폰함',
//                       ),
//                       SizedBox(
//                         height: 5,
//                       ),
//                       _model.couponList.isEmpty ? SizedBox(
//                         height: 200,
//                         width: MediaQuery.of(context).size.width,
//                         child: Center(
//                           child: Text(
//                             '현재 등록하신 쿠폰이 없습니다.'
//                           ),
//                         ),
//                       ):
//                       Column(
//                         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children:  _model.couponList.map((e) => CouponWidget(coupon: e)).toList(),
//         ),
//                       SizedBox(
//                         height: 15,
//                       ),
//                     ],
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//         if(_model.selectedCoupon != null)
//           BottomFloatButton(text: '쿠폰 사용하기', onPressed: () {
//             Navigator.pop(context, _model.selectedCoupon);
//           },)
//       ],
//     );
//   }
// }
