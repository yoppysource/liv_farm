import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/services/server_service/APIException.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class EventBannerViewModel extends FutureViewModel {
    List eventsDataList;
     final ServerService _serverService = locator<ServerService>();
  final DialogService _dialogService = locator<DialogService>();
    @override
  Future<void> futureToRun() async {
    this.eventsDataList =
        await _serverService.getData(resource: Resource.events);

  }
  @override
  void onError(error) {
    if (error is APIException) {
      _dialogService.showDialog(title: "오류", description: error.message);
    } else {
      throw error;
    }
  }

}