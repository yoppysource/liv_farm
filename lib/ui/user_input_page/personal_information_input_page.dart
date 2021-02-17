import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/formatter.dart';
import 'package:liv_farm/ui/shared/appbar.dart';
import 'package:liv_farm/ui/shared/buttons/bottom_float_buttom.dart';
import 'package:liv_farm/ui/shared/platform_widget/my_text_field.dart';
import 'package:liv_farm/viewmodel/user_input_page_view_model.dart';
import 'package:provider/provider.dart';

class PersonalInformationInputPage extends StatefulWidget {
  @override
  _PersonalInformationInputPageState createState() =>
      _PersonalInformationInputPageState();
}

class _PersonalInformationInputPageState
    extends State<PersonalInformationInputPage> with Formatter {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    UserInputPageViewModel _model =
        Provider.of<UserInputPageViewModel>(context, listen: false);
    _nameController.text = _model.myUser.name ?? '';
    _emailController.text = _model.myUser.email ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _nameController?.dispose();
    _emailController?.dispose();
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
              onPressed: Platform.isAndroid ? null : () async {
                await _model.submitForPersonalInfo(name: _nameController.text, email: _emailController.text);
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
                    ) ,
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '이메일',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    PlatformTextField(
                      controller: _emailController,
                      hintText: '이메일',
                      textInputType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    // Text(
                    //   '성별',
                    //   style: TextStyle(color: Colors.grey, fontSize: 15),
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // _model.selectedGender == ''
                    //     ? Center(
                    //       child: FlatButton(
                    //           onPressed: _model.updateGender, child: Text('선택하기')),
                    //     )
                    //     : Center(
                    //         child: AnimatedContainer(
                    //           duration: Duration(milliseconds: 1000),
                    //           height: 35,
                    //           width: 90,
                    //           decoration: BoxDecoration(
                    //               border: Border.all(
                    //                   color: Colors.grey.withOpacity(0.5)),
                    //               borderRadius: BorderRadius.circular(5.0),
                    //               color: Colors.white),
                    //           child: Stack(
                    //             children: <Widget>[
                    //               AnimatedPositioned(
                    //                 duration: Duration(milliseconds: 1000),
                    //                 curve: Curves.easeIn,
                    //                 left: _model.selectedGender == 'male' //남자일경
                    //                     ? 50
                    //                     : 0.0,
                    //                 right: _model.selectedGender == 'male' ? 0.0 : 50,
                    //                 child: InkWell(
                    //                   onTap: _model.updateGender,
                    //                   child: AnimatedSwitcher(
                    //                     duration: Duration(milliseconds: 1000),
                    //                     transitionBuilder: (Widget child,
                    //                         Animation<double> animation) {
                    //                       return RotationTransition(
                    //                         child: child,
                    //                         turns: animation,
                    //                       );
                    //                     },
                    //                     child: _model.selectedGender == 'male'
                    //                         ? Icon(
                    //                             FontAwesomeIcons.mars,
                    //                             color: Colors.blueAccent
                    //                                 .withOpacity(0.6),
                    //                             size: 28,
                    //                             key: UniqueKey(),
                    //                           )
                    //                         : Icon(
                    //                             FontAwesomeIcons.venus,
                    //                             color: Colors.pinkAccent
                    //                                 .withOpacity(0.6),
                    //                             size: 28,
                    //                             key: UniqueKey(),
                    //                           ),
                    //                   ),
                    //                 ),
                    //               ),
                    //             ],
                    //           ),
                    //         ),
                    //       ),
                    // SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   '생년월일',
                    //   style: TextStyle(color: Colors.grey, fontSize: 15),
                    // ),
                    // SizedBox(
                    //   height: 15,
                    // ),
                    // Center(
                    //   child: Container(
                    //     height: 35,
                    //     width: 200,
                    //     child: FlatButton(
                    //       onPressed: () async {
                    //         await _model.updateBirthDate(context);
                    //       },
                    //       child: Text(
                    //         _model.selectedBirthDate == null
                    //             ? '생년월일을 선택해주세요'
                    //             : getStringFromDatetime(_model.selectedBirthDate),
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if(Platform.isAndroid)
        BottomFloatButton(text: '저장하기',
        onPressed:() async {
          await _model.submitForPersonalInfo(name: _nameController.text, email: _emailController.text);
          Navigator.of(context).pop();
          },)
      ],
    );
  }
}
