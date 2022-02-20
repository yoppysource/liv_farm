extension DateTimeExtension on DateTime {
  String get weekdayInKor {
    if (weekday == 1) {
      return '월요일';
    } else if (weekday == 2) {
      return '화요일';
    } else if (weekday == 3) {
      return '수요일';
    } else if (weekday == 4) {
      return '목요일';
    } else if (weekday == 5) {
      return '금요일';
    } else if (weekday == 6) {
      return '토요일';
    } else {
      return '일요일';
    }
  }
}
