import 'package:flutter/material.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/pick_date_time_bottom_sheet/pick_date_time_bottom_sheet_viewmodel.dart';
import 'package:liv_farm/util/delivery_reservation_caluator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class DeliveryReservationViewModel extends FutureViewModel {
  Map<DateTime, List<TimeOfDay>> dateTimePairedWithTimeOfDayList;
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  DateTime now = DateTime.now();
  DeliveryReservationCaluator caluator;
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.openingHour));

  DateTime selectedDateTime = locator<ShoppingCartViewModel>().selectedDateTime;
  String get message {
    String message = '';
    if (selectedDateTime == null) {
      if (caluator.isPossibleToBuyNow(this.now)) {
        message = "주문 후 바로 수확하여 30분 내 배송";
      } else if (dateTimePairedWithTimeOfDayList.keys.first.day ==
          this.now.day) {
        message = "아침 9시에 수확하여 30분 내로 배송";
      } else {
        message =
            "${dateTimePairedWithTimeOfDayList.keys.first.day}(${getWeekDaysName(dateTimePairedWithTimeOfDayList.keys.first)}) 9시에 수확하여 30분 내로 배송";
      }
    } else {
      message =
          "${selectedDateTime.day}(${getWeekDaysName(selectedDateTime)}) ${selectedDateTime.hour}시${selectedDateTime.minute == 0 ? '' : " " + selectedDateTime.minute.toString() + '분'}에 수확하여 30분 내로 배송";
    }
    locator<ShoppingCartViewModel>().deliveryReservationMessage = message;
    return message;
  }

  @override
  Future futureToRun() async {
    Map<String, dynamic> data =
        await _serverService.getData(path: "/openingHour");
    caluator = DeliveryReservationCaluator(
      DateTime.now(),
      data["data"]['isOpenSaturday'],
      data["data"]['isOpenSunday'],
      data["data"]['isOpenToday'],
      data["data"]['openHourStr'],
      data["data"]['closeHourStr'],
    );
    this.dateTimePairedWithTimeOfDayList =
        caluator.getDateTimePairedWithTimeOfDayList();
    print(this.dateTimePairedWithTimeOfDayList.toString());
  }

  String reservationMessage;

  Future callBottomSheetToGetDateTime() async {
    if (this.isBusy == true) return;
    this.selectedDateTime = null;

    SheetResponse _sheetResponse = await _bottomSheetService.showCustomSheet(
        isScrollControlled: true,
        variant: BottomSheetType.GetDateTime,
        title: this.message,
        customData: this.dateTimePairedWithTimeOfDayList);
    if (_sheetResponse.confirmed) {
      selectedDateTime = _sheetResponse
          .responseData[PickDateTimeBottomSheetViewModel.KEY_selectedDate];
      print('result : ${this.selectedDateTime}');
      notifyListeners();
    }
  }

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
}
