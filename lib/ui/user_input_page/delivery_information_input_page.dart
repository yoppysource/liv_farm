import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/edit_button.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
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

  @override
  void initState() {
    UserInputPageViewModel _model =
        Provider.of<UserInputPageViewModel>(context, listen: false);
    _addressDetailController.text = _model.myUser.addressDetail ?? '';
    _phoneNumberController.text = _model.myUser.phoneNumber ?? '';
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
    return Scaffold(
      appBar: MyAppBar(
          title: '배송 정보 수정',
          onPressed: () async {
            widget.purpose ==DeliveryInformationPurpose.general ?await _model.submitForDeliveryInfo(addressDetail: _addressDetailController.text, phoneNumber: _phoneNumberController.text) : await _model.submitWithCheck();
            Navigator.of(context).pop();
          }),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.88,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 50,
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
                    Container(
                      height: 30,
                      width: 90,
                      child: MaterialButton(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          color: Colors.grey.withOpacity(0.85),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Center(
                                  child: Padding(
                                padding: const EdgeInsets.only(left: 3),
                                child: Text(
                                  '주소 찾기',
                                  style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.95)),
                                ),
                              )),
                            ],
                          ),
                          onPressed: () async {
                            await _model.updatePostcodeAndAddress(context);
                          }),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      (_model.selectedPostCode == null ||
                          _model.selectedPostCode == '')
                          ? '우편번호를 입력해 주세요'
                          : _model.selectedPostCode,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 30,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      (_model.selectedAddress == null ||
                              _model.selectedAddress == '')
                          ? '주소를 입력해 주세요'
                          : _model.selectedAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black.withOpacity(0.7),
                      ),
                    ),
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
