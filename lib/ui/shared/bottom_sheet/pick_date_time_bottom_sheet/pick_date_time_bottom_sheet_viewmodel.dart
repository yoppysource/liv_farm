import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PickDateTimeBottomSheetViewModel extends BaseViewModel {
  final Map<DateTime, List<TimeOfDay>> data;
  String defaultString;
  static const String KEY_selectedDate = 'selectedDate';
  static const String KEY_deliveryGuideMessage = 'deliveryGuide';
  List<String> weekDayNameList = ['월','화','수', '목', '금','토', '일'];
  DateTime selectedDateTime;
  TimeOfDay selectedTimeOfDay;
  DateTime finalDateTime;
  int selectedIndex = 0;
  bool isHourSelected = false;

  PickDateTimeBottomSheetViewModel(this.defaultString, this.data);

  String get message => selectedDateTime == null
      ? defaultString
      : selectedTimeOfDay == null
          ? "시간을 선택해 주세요"
          : "${finalDateTime.day}일(${weekDayNameList[finalDateTime.weekday-1]}) ${finalDateTime.hour}시${finalDateTime.minute == 0 ? '' : " " + finalDateTime.minute.toString() + '분'}에 받기";

  void onPressedDateButton(int index) {
    selectedIndex = index;
    selectedDateTime = null;
    isHourSelected = false;
    if (index != 0) {
      selectedDateTime = data.keys.elementAt(index - 1);
    }
    if (index == 0) {}
    notifyListeners();
  }

  void onHourSelected(TimeOfDay timeOfDay) {
    selectedTimeOfDay = timeOfDay;

    finalDateTime = new DateTime(selectedDateTime.year, selectedDateTime.month,
        selectedDateTime.day, timeOfDay.hour, timeOfDay.minute);
    notifyListeners();
  }
}
