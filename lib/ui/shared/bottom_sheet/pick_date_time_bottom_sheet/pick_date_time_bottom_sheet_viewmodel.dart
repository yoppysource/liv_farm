import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class PickDateTimeBottomSheetViewModel extends BaseViewModel {
  final Map<DateTime, List<TimeOfDay>> data;
  final String defaultString;
  static const String KEY_selectedDate = 'selectedDate';
  static const String KEY_deliveryGuideMessage = 'deliveryGuide';
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
          : "${finalDateTime.day}(${getWeekDaysName(finalDateTime)}) ${finalDateTime.hour}시${finalDateTime.minute == 0 ? '' : " " + finalDateTime.minute.toString() + '분'}에 수확하여 30분 내로 배송";

  String getWeekDaysName(DateTime dateTime) {
    if (dateTime.weekday == 1) {
      return '월';
    } else if (dateTime.weekday == 2) {
      return '화';
    } else if (dateTime.weekday == 3) {
      return '수';
    } else if (dateTime.weekday == 4) {
      return '목';
    } else if (dateTime.weekday == 5) {
      return '금';
    } else if (dateTime.weekday == 6) {
      return '토';
    } else {
      return '일';
    }
  }

  void onPressedDateButton(int index) {
    selectedIndex = index;
    selectedDateTime = null;
    isHourSelected = false;
    if (index != 0) {
      selectedDateTime = data.keys.elementAt(index - 1);
    }
    notifyListeners();
  }

  void onHourSelected(TimeOfDay timeOfDay) {
    selectedTimeOfDay = timeOfDay;

    finalDateTime = new DateTime(selectedDateTime.year, selectedDateTime.month,
        selectedDateTime.day, timeOfDay.hour, timeOfDay.minute);
    notifyListeners();
  }
}
