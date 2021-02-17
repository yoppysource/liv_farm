import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kopo/kopo.dart';
import 'package:liv_farm/model/address.dart';
import 'package:liv_farm/ui/address_select_page/kakao_map_page.dart';
import 'package:liv_farm/ui/product_description_page/product_description_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';

class AddressSelectPage extends StatelessWidget {
  final UserInputPageViewModel model;

  const AddressSelectPage({Key key, this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: '배송지 주소 설정',
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () async {
                KopoModel kopoModel = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => Kopo(),
                  ),
                );
                if (model != null) {
                  print('${kopoModel.jibunAddress}');
                  Address address = Address(
                    address: kopoModel.address,
                    postCode: kopoModel.zonecode,
                  );
                  bool isValid = false;
                  if (kopoModel.jibunAddress.contains('성남')) {
                    Address.validAddress.forEach((element) {
                      if (kopoModel.jibunAddress.contains(element)) {
                        isValid = true;
                        return;
                      }
                    });
                  }
                  if (isValid == false) {
                    PlatformAlertDialog(
                      title: '알림',
                      widget: Text('죄송합니다. 배송이 불가능한 지역입니다.'),
                      defaultActionText: '확인',
                    ).show(context);
                  } else {
                    model.updatePostcodeAndAddress(address);
                    Navigator.pop(context);
                  }
                }
              },
              child: MyCard(
                child: Padding(
                  padding:
                      const EdgeInsets.only(right: 10, top: 20, bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        CupertinoIcons.search,
                        size: 22,
                      ),
                      Text(
                        '도로명 건물명 또는 지번으로 검색하기',
                        style: TextStyle(fontSize: 16),
                      ),
                      Icon(
                        CupertinoIcons.search,
                        color: Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // MyCard(
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Padding(
            //         padding: const EdgeInsets.symmetric(
            //             horizontal: 10, vertical: 20),
            //         child: GestureDetector(
            //           onTap: () async {
            //             Map<String, dynamic> data = await Navigator.push(
            //               context,
            //               CupertinoPageRoute(
            //                 builder: (context) => KakaoMapPage(),
            //               ),
            //             );
            //             print(data);
            //             if (data != null) {
            //               Address address = Address(
            //                   address: data['address'],
            //                   postCode: data['postCode']);
            //               model.updatePostcodeAndAddress(address);
            //               Navigator.pop(context);
            //             }
            //           },
            //           child: Container(
            //             height: 50,
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(5),
            //                 border:
            //                     Border.all(color: Colors.black54, width: 0.5)),
            //             child: Row(
            //               mainAxisAlignment: MainAxisAlignment.center,
            //               children: [
            //                 Icon(
            //                   CupertinoIcons.location,
            //                   size: 22,
            //                 ),
            //                 SizedBox(
            //                   width: 10,
            //                 ),
            //                 Text(
            //                   '현재 위치로 주소 찾기',
            //                   style: TextStyle(fontSize: 16),
            //                 ),
            //               ],
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            MyCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SizedBox(height: 10,),
                  // TitleText(
                  //   text: '배송 가능 지역 안내',
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: Text('* 현재 배송 가능 지역은 성남시 중원구, 수정구(일부), 분당구(일부)입니다.', style: TextStyle(fontSize: 12),),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Image.asset('assets/images/delivery_possible_image.jpeg'),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
