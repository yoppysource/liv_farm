import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class ChangePasswordBottomSheetView extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Widget child;

  const ChangePasswordBottomSheetView(
      {Key key, this.request, this.completer, this.child})
      : super(key: key);

  @override
  _ChangePasswordBottomSheetViewState createState() =>
      _ChangePasswordBottomSheetViewState();
}

class _ChangePasswordBottomSheetViewState
    extends State<ChangePasswordBottomSheetView> {
  final Color buttonTextColor = kMainPink;
  TextEditingController _currentPasswordTextEditingController;
  TextEditingController _newPasswordTextEditingController;
  TextEditingController _newPasswordConfirmTextEditingController;
  final FocusNode newpasswordFocusNode = FocusNode();
  final FocusNode newpasswordConfirmFocusNode = FocusNode();
  bool isValid = true;
  String message = '';

  @override
  void initState() {
    _currentPasswordTextEditingController = TextEditingController();
    _newPasswordTextEditingController = TextEditingController();
    _newPasswordConfirmTextEditingController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    newpasswordFocusNode.dispose();
    newpasswordConfirmFocusNode.dispose();
    _currentPasswordTextEditingController?.dispose();
    _newPasswordTextEditingController?.dispose();
    _newPasswordConfirmTextEditingController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (_) {},
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '비밀번호 변경',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                verticalSpaceRegular,
                TextField(
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: kMainPink,
                  controller: _currentPasswordTextEditingController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black87),
                  obscureText: true,
                  onEditingComplete: () =>
                      FocusScope.of(context).requestFocus(newpasswordFocusNode),
                  decoration: InputDecoration(
                    hintText: '현재 비밀번호',
                    focusColor: kMainPink,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: kMainBlack, width: 0.5)),
                  ),
                  autofocus: true,
                ),
                verticalSpaceTiny,
                TextField(
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: kMainPink,
                  focusNode: newpasswordFocusNode,
                  controller: _newPasswordTextEditingController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black87),
                  obscureText: true,
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(newpasswordConfirmFocusNode),
                  decoration: InputDecoration(
                    hintText: '새로운 비밀번호',
                    focusColor: kMainPink,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: kMainBlack, width: 0.5)),
                  ),
                ),
                verticalSpaceTiny,
              
                TextField(
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: kMainPink,
                  controller: _newPasswordConfirmTextEditingController,
                  style: Theme.of(context)
                      .textTheme
                      .bodyText2
                      .copyWith(color: Colors.black87),
                  obscureText: true,
                  focusNode: newpasswordConfirmFocusNode,
                  onEditingComplete: () => FocusScope.of(context)
                      .requestFocus(newpasswordConfirmFocusNode),
                  decoration: InputDecoration(
                    hintText: '새로운 비밀번호 확인',
                    focusColor: kMainPink,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: kMainBlack, width: 0.5)),
                  ),
                ),
              if (!isValid)
                  Column(
                    children: [
                      Text(
                        message,
                        style: TextStyle(color: Colors.redAccent),
                      ),
                      verticalSpaceTiny,
                    ],
                  ),
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () =>
                            widget.completer(SheetResponse(confirmed: false)),
                        child: Text(
                          '뒤로가기',
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                          title: '변경하기',
                          color: kMainPink,
                          onPressed:() {
            onPressedChange(currentPasswordTextEditingController: _currentPasswordTextEditingController, newPasswordConfirmTextEditingController: _newPasswordTextEditingController, newPasswordTextEditingController: _newPasswordConfirmTextEditingController,);
                          } ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onPressedChange(
      {TextEditingController currentPasswordTextEditingController,
      TextEditingController newPasswordTextEditingController,
      TextEditingController newPasswordConfirmTextEditingController}) {
    if (currentPasswordTextEditingController.text.length < 6 ||
        newPasswordTextEditingController.text.length < 6 ||
        newPasswordConfirmTextEditingController.text.length < 6) {
      setState(() {
        isValid = false;
        message = '비밀번호가 너무 짧습니다';
        currentPasswordTextEditingController.text = '';
        newPasswordTextEditingController.text = '';
        newPasswordConfirmTextEditingController.text = '';
      });
    } else if (newPasswordTextEditingController.text.trim() !=
        newPasswordConfirmTextEditingController.text.trim()) {
      setState(() {
        isValid = false;
        message = '비밀번호가 서로 일치하지 않습니다';
        currentPasswordTextEditingController.text = '';
        newPasswordTextEditingController.text = '';
        newPasswordConfirmTextEditingController.text = '';
      });
    } else {
          return widget.completer(SheetResponse(confirmed: true, responseData: {
      'currentPassword': currentPasswordTextEditingController.text.trim(),
      'newPassword': newPasswordTextEditingController.text.trim(),
    }));
    }
  }
}
