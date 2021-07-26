import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/inventory.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/server_service.dart';
import 'package:liv_farm/services/toast_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:liv_farm/ui/shared/bottom_sheet/bottom_sheet_type.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class OrderHistoryViewModel extends FutureViewModel {
  List<Order> yetCompleteOrderList = [];
  List<Order> completeOrderList = [];

  AnalyticsService _analyticsService = locator<AnalyticsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  NavigationService _navigationService = locator<NavigationService>();
  ServerService _serverService = locator<ServerService>();

  @override
  Future futureToRun() async {
    yetCompleteOrderList = [];
    completeOrderList = [];
    try {
      List data =
          await _serverService.getData<List>(resource: Resource.orders, path: "/my");
      List dataList = data;
      dataList.forEach((data) {
        Order order = Order.fromJson(data);
        if (order.status < 2) {
          yetCompleteOrderList.add(order);
        } else {
          completeOrderList.add(order);
        }
      });
    } catch (e) {
      throw e;
    }
  }

  void navigateToProductDetail(Inventory inventory) {
    _analyticsService.logViewItem(
        itemId: inventory.product.id,
        itemName: inventory.product.name,
        itemCategory: inventory.product.category.toString(),
        price: inventory.product.price.toDouble(),
        currency: 'won');
    _navigationService.navigateWithTransition(
        ProductDetailView(
          inventory: inventory,
        ),
        transition: 'fade');
  }

  Future<void> updateIsReviewedInOrder(String orderId) async {
    await _serverService
        .patchData(resource: Resource.orders, path: '/$orderId', data: {"isReviewed": true});
  }

  Future<Map<String, dynamic>> getMapFromBottomSheet() async {
    SheetResponse sheetResponse = await _bottomSheetService.showCustomSheet(
        variant: BottomSheetType.Review);
    if (sheetResponse.confirmed) return sheetResponse.responseData;
    return Map();
  }

  Future<void> createReview(String productId, String orderId) async {
    Map<String, dynamic> reviewData = await getMapFromBottomSheet();

    if (reviewData.isNotEmpty) {
      reviewData["userName"] = _userProviderService.user.name;
      try {
        await _serverService.postData(resource: Resource.products,
            path: "/$productId/reviews", data: reviewData);
        await updateIsReviewedInOrder(orderId);
        ToastMessageService.showToast(message: "리뷰 작성에 성공하였습니다.");
      } catch (e) {
        ToastMessageService.showToast(message: "리뷰 작성에 실패하였습니다.");
        print(e.message.toString());
      }
    }
  }
}
