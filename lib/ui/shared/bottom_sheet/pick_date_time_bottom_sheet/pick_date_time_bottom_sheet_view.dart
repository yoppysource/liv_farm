import 'package:flutter/material.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/pick_date_time_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/time_picker/time_list.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/setup_bottom_sheet.dart';
import 'package:liv_farm/ui/shared/styles.dart';
import 'package:stacked/stacked.dart';
import 'package:liv_farm/util/time_of_day_extension.dart';
import 'package:stacked_services/stacked_services.dart';

class PickDateTimeBottomSheetView extends StatelessWidget {
  final SheetRequest request;

  final Function(SheetResponse) completer;

  const PickDateTimeBottomSheetView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PickDateTimeBottomSheetViewModel>.reactive(
      viewModelBuilder: () =>
          PickDateTimeBottomSheetViewModel(request.title!, request.data),
      builder: (context, model, child) => GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '시간 선택',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DateButton(
                      model: model,
                      index: 0,
                      label: '기본',
                    ),
                    DateButton(
                      model: model,
                      index: 1,
                      label:
                          '${model.data.keys.elementAt(0).day}(${model.weekDayNameList[model.data.keys.elementAt(0).weekday - 1]})',
                    ),
                    DateButton(
                      model: model,
                      index: 2,
                      label:
                          '${model.data.keys.elementAt(1).day}(${model.weekDayNameList[model.data.keys.elementAt(1).weekday - 1]})',
                    ),
                  ],
                ),
                verticalSpaceMedium,
                model.selectedIndex == 0
                    ? Container()
                    : (model.selectedIndex == 1 &&
                            (model.data.values.elementAt(0)[0] ==
                                    model.data.values.elementAt(0)[1] ||
                                (model.data.values
                                    .elementAt(0)[0]
                                    .after(model.data.values.elementAt(0)[1]))))
                        ? const Center(
                            child: Text('선택가능한 시간이 없습니다.'),
                          )
                        : TimeList(
                            timeStep: 30,
                            initialTime: const TimeOfDay(hour: 9, minute: 40),
                            firstTime: model.data.values
                                .elementAt(model.selectedIndex - 1)[0],
                            lastTime: model.data.values
                                .elementAt(model.selectedIndex - 1)[1],
                            onHourSelected: model.onHourSelected,
                          ),
                verticalSpaceMedium,
                Text(
                  '시간 안내',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
                verticalSpaceRegular,
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text(
                      model.message,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ),
                ),
                verticalSpaceMedium,
                verticalSpaceMedium,
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: TextButton(
                        onPressed: () =>
                            completer(SheetResponse(confirmed: false)),
                        child: const Text(
                          '뒤로가기',
                          style: TextStyle(color: kMainPink, fontSize: 18),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FullScreenButton(
                        title: '선택하기',
                        color: kMainPink,
                        onPressed: () =>
                            completer(SheetResponse(confirmed: true, data: {
                          PickDateTimeBottomSheetViewModel.KEY_selectedDate:
                              model.finalDateTime,
                        })),
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

class DateButton extends StatelessWidget {
  final PickDateTimeBottomSheetViewModel model;
  final int index;
  final String label;

  const DateButton(
      {Key? key, required this.model, required this.index, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        model.onPressedDateButton(index);
      },
      child: Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          color: index == model.selectedIndex ? kMainPink : Colors.white,
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
              color: index == model.selectedIndex ? Colors.white : kMainPink),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(label,
                style: index == model.selectedIndex
                    ? Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: Colors.white, fontSize: 20)
                    : Theme.of(context)
                        .textTheme
                        .bodyText1!
                        .copyWith(color: kMainBlack, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
