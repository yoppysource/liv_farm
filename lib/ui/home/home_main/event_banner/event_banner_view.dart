import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/events.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:stacked/stacked.dart';

class EventBannerViewModel extends BaseViewModel {
  List<Event>? eventsList;
  final ClientService _clientService = locator<ClientService>();
  int pageIndex = 0;

  // Future<void> futureToRun() async {
  //   eventsDataList = await _serverService.sendRequest(
  //       method: HttpMethod.get, resource: Resource.events);
  // }

  Future getEvent() async {
    try {
      List data = await _clientService.sendRequest<List>(
        method: HttpMethod.get,
        resource: Resource.events,
      );
      eventsList = data.map((e) => Event.fromJson(e)).toList();
    } catch (e) {
      ToastMessageService.showToast(message: "상품정보를 가져오는데 실패하였습니다.");
    }
  }

  void setPageIndex(int index) {
    pageIndex = index;
    notifyListeners();
  }
}
