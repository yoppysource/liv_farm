import 'package:flutter/material.dart';
import 'package:liv_farm/model/store.dart';
import 'time_of_day_extension.dart';

class OrderReservationCaluator {
  final DateTime now;
  final Store store;
  Map<DateTime, List<TimeOfDay>>? dateTimePairedWithTimeOfDayList;

  OrderReservationCaluator({required this.store, required this.now}) {
    getDateTimePairedWithTimeOfDayList();
  }

  TimeOfDay get openHour => TimeOfDay(
      hour: int.parse(store.openHourStr.split(':')[0]),
      minute: int.parse(store.openHourStr.split(':')[1]));
  TimeOfDay get closeHour => TimeOfDay(
      hour: int.parse(store.closeHourStr.split(':')[0]),
      minute: int.parse(store.closeHourStr.split(':')[1]));

  bool get availableNow {
    if (!store.isOpenToday || store.holidays.contains(now.weekday)) {
      return false;
    }
    TimeOfDay nowTimeOfDay = TimeOfDay.fromDateTime(now);
    return (nowTimeOfDay.after(openHour) && nowTimeOfDay.before(closeHour));
  }

  bool get isTodayOpen {
    if (!store.isOpenToday || store.holidays.contains(now.weekday)) {
      return false;
    }
    return true;
  }

  void getDateTimePairedWithTimeOfDayList() {
    Map<DateTime, List<TimeOfDay>> dateTimePairedWithTimeOfDayList = {};
    if (availableNow) {
      TimeOfDay startTime =
          TimeOfDay(hour: now.hour + 1, minute: now.minute >= 30 ? 30 : 0);
      dateTimePairedWithTimeOfDayList[now] = [startTime, closeHour];
    } else if (TimeOfDay.fromDateTime(now).before(openHour) && isTodayOpen) {
      dateTimePairedWithTimeOfDayList[now] = [openHour, closeHour];
    } else {
      dateTimePairedWithTimeOfDayList[getNextDateBySkippingHolidays(now)] = [
        openHour,
        closeHour
      ];
    }
    DateTime secondDate = getNextDateBySkippingHolidays(
        dateTimePairedWithTimeOfDayList.keys.first);
    dateTimePairedWithTimeOfDayList[secondDate] = [openHour, closeHour];
    dateTimePairedWithTimeOfDayList[getNextDateBySkippingHolidays(secondDate)] =
        [openHour, closeHour];

    this.dateTimePairedWithTimeOfDayList = dateTimePairedWithTimeOfDayList;
  }

  DateTime getNextDateBySkippingHolidays(DateTime dateTime) {
    DateTime nextDate = dateTime.add(const Duration(days: 1));

    while (store.holidays.contains(nextDate.weekday)) {
      nextDate = nextDate.add(const Duration(days: 1));
    }
    return nextDate;
  }
}
