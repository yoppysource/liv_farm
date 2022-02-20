import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class WriteBottomSheetView extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const WriteBottomSheetView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  _WriteBottomSheetViewState createState() => _WriteBottomSheetViewState();
}

class _WriteBottomSheetViewState extends State<WriteBottomSheetView> {
  final Color buttonTextColor = kMainPink;
  late TextEditingController _textEditingController;

  @override
  void initState() {
    _textEditingController = TextEditingController();
    _textEditingController.text = widget.request.data['text'] ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.request.title!,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                verticalSpaceMedium,
                TextField(
                  scrollPadding: EdgeInsets.zero,
                  cursorColor: kMainPink,
                  controller: _textEditingController,
                  style: Theme.of(context).textTheme.bodyText1,
                  maxLength: widget.request.data['maxLength'] ?? 10,
                  keyboardType:
                      widget.request.data['keyboardType'] ?? TextInputType.text,
                  decoration: InputDecoration(
                    hintText: widget.request.data['hintText'],
                    focusColor: kMainPink,
                    focusedBorder: const OutlineInputBorder(
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
                        child: const Text(
                          '뒤로가기',
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                        title: '저장하기',
                        color: kMainPink,
                        onPressed: () => widget.completer(SheetResponse(
                            confirmed: true,
                            data: {'input': _textEditingController.text})),
                      ),
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
