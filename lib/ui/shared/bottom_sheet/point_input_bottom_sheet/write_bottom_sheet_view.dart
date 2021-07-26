import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class PointInputBottomSheetView extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;
  final Widget child;

  const PointInputBottomSheetView(
      {Key key, this.request, this.completer, this.child})
      : super(key: key);

  @override
  _WriteBottomSheetViewState createState() => _WriteBottomSheetViewState();
}

class _WriteBottomSheetViewState extends State<PointInputBottomSheetView> {
  final Color buttonTextColor = kMainPink;
  TextEditingController _textEditingController;
  int availablePoint = 0;
  final DialogService _dialogService = locator<DialogService>();

  @override
  void initState() {
    _textEditingController = TextEditingController();
    availablePoint = widget.request.customData['availablePoint'];
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController?.dispose();
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
                  widget.request.title,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: FlatButton(
                    child: Text('전액 사용',
                        style: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .copyWith(color: kSubColor)),
                    onPressed: () {
                      _textEditingController.text = availablePoint.toString();
                    },
                  ),
                ),
                TextField(
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: kMainPink,
                  controller: _textEditingController,
                  style: Theme.of(context).textTheme.bodyText1,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: widget.request.customData['hintText'],
                    focusColor: kMainPink,
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: kMainBlack, width: 0.5)),
                  ),
                  autofocus: true,
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
                          title: '포인트 적용',
                          color: kMainPink,
                          onPressed: () {
                            try {
                              int pointInput = int.tryParse(
                                  _textEditingController.text.trim());
                              if (pointInput > availablePoint) {
                                return _dialogService.showDialog(
                                    title: "오류",
                                    description:
                                        "$availablePoint보다 같거나 작은 숫자를 입력해주세요",
                                    buttonTitle: "확인");
                              }
                              if (pointInput < 0) {
                                return _dialogService.showDialog(
                                    title: "오류",
                                    description: "포인트 입력값이 잘못되었습니다",
                                    buttonTitle: "확인");
                              }
                              widget.completer(SheetResponse(
                                  confirmed: true,
                                  responseData: {'pointInput': pointInput}));
                            } catch (e) {
                              return _dialogService.showDialog(
                                  title: "오류",
                                  description: "숫자만 기입가능합니다",
                                  buttonTitle: "확인");
                            }
                          }),
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
}
