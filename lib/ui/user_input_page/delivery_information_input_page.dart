import 'package:flutter/material.dart';
import 'package:liv_farm/constant.dart';
import 'package:liv_farm/ui/address_select_page/address_select_page.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/platform_widget/dialogs/alert_dialog.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'dart:io';
import 'package:provider/provider.dart';

enum DeliveryInformationPurpose { purchase, general }

class DeliveryInformationInputPage extends StatefulWidget {
  final DeliveryInformationPurpose purpose;

  const DeliveryInformationInputPage({Key key, this.purpose}) : super(key: key);

  @override
  _DeliveryInformationInputPageState createState() =>
      _DeliveryInformationInputPageState();
}

class _DeliveryInformationInputPageState
    extends State<DeliveryInformationInputPage> {
  TextEditingController _addressDetailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    UserInputPageViewModel _model =
        Provider.of<UserInputPageViewModel>(context, listen: false);
    _addressDetailController.text = _model.myUser.addressDetail ?? '';
    _phoneNumberController.text = _model.myUser.phoneNumber ?? '';
    _nameController.text = _model.myUser.name ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _addressDetailController?.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    UserInputPageViewModel _model =
        Provider.of<UserInputPageViewModel>(context, listen: true);
    return Stack(
      children: [
        Scaffold(
          appBar: MyAppBar(
                onPressed: Platform.isAndroid? null :() async {
                widget.purpose == DeliveryInformationPurpose.general
                    ? await _model.submitForDeliveryInfo(
                        addressDetail: _addressDetailController.text,
                        phoneNumber: _phoneNumberController.text)
                    : _model.isInformationAvailable(_addressDetailController.text,
                            _phoneNumberController.text, _nameController.text)
                        ? await _model.submitWithCheck(
                            name: _nameController.text,
                            addressDetail: _addressDetailController.text,
                            phoneNumber: _phoneNumberController.text)
                        : PlatformAlertDialog(
                                title: '오류',
                                widget: Text('배송 정보를 모두 입력해주세요'),
                                defaultActionText: '확인')
                            .show(context);

                  if(widget.purpose == DeliveryInformationPurpose.general || _model.isInformationAvailable(_addressDetailController.text, _phoneNumberController.text, _nameController.text))
                    Navigator.pop(context);
              }),
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.88,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.purpose == DeliveryInformationPurpose.purchase)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Text('* 모든 항목은 필수 입력 사항입니다'),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            '이름',
                            style: TextStyle(color: Colors.grey, fontSize: 15),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          PlatformTextField(
                            controller: _nameController,
                            hintText: '이름',
                            textInputType: TextInputType.name,
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Text(
                          '우편번호 / 주소',
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        SizedBox(
                          width: 20,
                        ),

                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Container(
                          width: 90,
                          child: PlatformTextField(
                            isForPostCode: true,
                           isForDesign: true,
                            text:  (_model.selectedPostCode == null ||
                                _model.selectedPostCode == '')
                                ? '우편번호'
                                : _model.selectedPostCode,
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(
                                fullscreenDialog: true,
                                builder: (context) => AddressSelectPage(model: _model,)));
                          },
                          child: Container(
                            padding: EdgeInsets.only(bottom: 1.5),
                            decoration: BoxDecoration(
                              color: Color(kSubColorRed).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 25,
                            width: 80,

                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                '주소 찾기',
                                style: TextStyle(
                                    fontSize: 13.5,
                                    color: Colors.white.withOpacity(0.95)),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PlatformTextField(
                      isForDesign: true,
                      text:   (_model.selectedAddress == null ||
                          _model.selectedAddress == '')
                          ? '주소를 입력해 주세요'
                          : _model.selectedAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '상세주소',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PlatformTextField(
                      hintText: '상세주소',
                      controller: _addressDetailController,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '전화번호',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PlatformTextField(
                      hintText: '전화번호',
                      textInputType: TextInputType.number,
                      controller: _phoneNumberController,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if(Platform.isAndroid)
        BottomFloatButton(
          text: '저장하기',
          onPressed: () async {
            widget.purpose == DeliveryInformationPurpose.general
                ? await _model.submitForDeliveryInfo(
                addressDetail: _addressDetailController.text,
                phoneNumber: _phoneNumberController.text)
                : _model.isInformationAvailable(_addressDetailController.text,
                _phoneNumberController.text, _nameController.text)
                ? await _model.submitWithCheck(
                name: _nameController.text,
                addressDetail: _addressDetailController.text,
                phoneNumber: _phoneNumberController.text)
                : PlatformAlertDialog(
                title: '오류',
                widget: Text('배송 정보를 모두 입력해주세요'),
                defaultActionText: '확인')
                .show(context);
            if(widget.purpose == DeliveryInformationPurpose.general || _model.isInformationAvailable(_addressDetailController.text, _phoneNumberController.text, _nameController.text))
              Navigator.pop(context);
          },
        )
      ],
    );
  }
}
