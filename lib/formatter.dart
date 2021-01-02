import 'package:intl/intl.dart';

class Formatter {
  String getStringFromDatetime(DateTime dateTime) {
    final df = new DateFormat('yyyy/MM/dd');

    return df.format(dateTime);
  }

  String getStringFromDateTimeInString(String str){
    return str.substring(0,10);
  }

  String getPriceFromInt(int price) {
    return NumberFormat('###,###,###,###원').format(price);
  }
}
