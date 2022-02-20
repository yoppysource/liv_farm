import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked_services/stacked_services.dart';

class GenderSelectBottomSheetView extends StatefulWidget {
  final SheetRequest request;
  final Function(SheetResponse) completer;

  const GenderSelectBottomSheetView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  _GenderSelectBottomSheetViewState createState() =>
      _GenderSelectBottomSheetViewState();
}

class _GenderSelectBottomSheetViewState
    extends State<GenderSelectBottomSheetView> {
  final Color buttonTextColor = kMainPink;
  String? selectedGender;

  @override
  void initState() {
    selectedGender = widget.request.data['gender'] ?? 'female';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                '성별',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              verticalSpaceMedium,
              Center(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedGender == 'male'
                          ? selectedGender = 'female'
                          : selectedGender = 'male';
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 1000),
                    height: 35,
                    width: 90,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(5.0),
                        color: Colors.white),
                    child: Stack(
                      children: <Widget>[
                        AnimatedPositioned(
                          duration: const Duration(milliseconds: 1000),
                          curve: Curves.easeIn,
                          left: selectedGender == 'male' //남자일경
                              ? 50
                              : 0.0,
                          right: selectedGender == 'male' ? 0.0 : 50,
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 1000),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return RotationTransition(
                                child: child,
                                turns: animation,
                              );
                            },
                            child: selectedGender == 'male'
                                ? Icon(
                                    FontAwesomeIcons.mars,
                                    color: Colors.blueAccent.withOpacity(0.6),
                                    size: 28,
                                    key: UniqueKey(),
                                  )
                                : Icon(
                                    FontAwesomeIcons.venus,
                                    color: Colors.pinkAccent.withOpacity(0.6),
                                    size: 28,
                                    key: UniqueKey(),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
                      onPressed: () => widget
                          .completer(SheetResponse(confirmed: true, data: {
                        'input': selectedGender,
                      })),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
