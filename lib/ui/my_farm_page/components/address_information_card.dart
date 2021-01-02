
import 'package:flutter/material.dart';
import 'package:liv_farm/model/my_user.dart';
import 'package:liv_farm/ui/shared/buttons/edit_button.dart';
import 'package:liv_farm/ui/shared/my_card.dart';
import 'package:liv_farm/ui/shared/text_with_title.dart';
import 'package:liv_farm/ui/shared/title_text.dart';
import 'package:liv_farm/ui/user_input_page/delivery_information_input_page.dart';
import 'package:liv_farm/viewmodel/my_farm_page_view_model.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'package:provider/provider.dart';

class AddressInformationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MyUser user = context.watch<MyFarmPageViewModel>().user;
    return MyCard(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleText(text: '배송지 정보'),
                  EditButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              ChangeNotifierProvider<UserInputPageViewModel>(
                                create: (context) => UserInputPageViewModel(
                                    Provider.of<MyFarmPageViewModel>(context,
                                        listen: false)),
                                child: DeliveryInformationInputPage(
                                  purpose: DeliveryInformationPurpose.general,
                                ),
                              ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(children: [
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWithTitle(
                      title: '우편번호',
                      text: (user?.postCode == null || user?.postCode == '')
                          ? '우편번호를 입력해 주세요'
                          : user.postCode,
                    ),
                    TextWithTitle(
                      title: '주소',
                      text: (user?.address == null || user?.address == '')
                          ? '주소를 입력해 주세요'
                          : user.address,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWithTitle(
                      title: '상세 주소',
                      text: (user?.addressDetail == '' ||
                          user?.addressDetail == null)
                          ? '상세 주소를 입력해 주세요'
                          : user.addressDetail,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    TextWithTitle(
                      title: '전화번호',
                      text:
                      (user?.phoneNumber == '' || user?.phoneNumber == null)
                          ? '전화번호를 입력해 주세요'
                          : user.phoneNumber,
                    ),
                  ],
                ),
              ]),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
