import 'package:iamport_flutter/model/payment_data.dart';
import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/home_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PurchaseViewModel extends BaseViewModel {
  final PaymentData paymentData;
  final Order order;
  ServerService _serverService =
      ServerService(apiPath: APIPath(resource: Resource.orders));
  bool isBusy = false;
  NavigationService _navigationService = locator<NavigationService>();
  DialogService _dialogService = locator<DialogService>();
  ShoppingCartViewModel _shoppingCartViewModel =
      locator<ShoppingCartViewModel>();
  PurchaseViewModel(this.paymentData, this.order);

  void onPressedArrowBack() {
    _navigationService.back();
    _dialogService.showDialog(
      title: '결제취소',
      description: '결제를 취소하셨거나 실패하셨습니다.',
      buttonTitle: '확인',
      barrierDismissible: false,
    );
  }

  Future<void> callback(Map<String, String> result) async {
    isBusy = true;
    notifyListeners();
    if (result['imp_success'] == 'true') {
      try {
        final Map<String, dynamic> data =
            await _serverService.postData(data: order.toJson());
        print(data);
        await _shoppingCartViewModel.syncCart();
        _navigationService.back();
        _dialogService.showDialog(
          title: '결제완료',
          description: '결제가 성공적으로 처리되었습니다. 하단의 주문내역을 통해서 확인하세요.',
          buttonTitle: '확인',
          barrierDismissible: false,
        );
      } catch (e) {
        print(e);
        _navigationService.back();
        _dialogService.showDialog(
          title: '결제오류',
          description: '결제에 실패하셨습니다. 만약 결제가 승인 나셨다면, 고객센터로 연락 부탁드립니다.',
          buttonTitle: '확인',
          barrierDismissible: false,
        );
      }
    } else {
      _navigationService.back();
      _dialogService.showDialog(
        title: '결제취소',
        description: '결제를 취소하셨거나 실패하셨습니다.',
        buttonTitle: '확인',
        barrierDismissible: false,
      );
    }
  }
}
