import 'package:liv_farm/app/app.locator.dart';
import 'package:liv_farm/model/order.dart';
import 'package:liv_farm/model/product.dart';
import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/server_service/API_path.dart';
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

  ServerService _ordersServerService =
      ServerService(apiPath: APIPath(resource: Resource.orders));
  ServerService _reviewsServerService =
      ServerService(apiPath: APIPath(resource: Resource.products));

  AnalyticsService _analyticsService = locator<AnalyticsService>();
  BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  UserProviderService _userProviderService = locator<UserProviderService>();
  NavigationService _navigationService = locator<NavigationService>();

  @override
  Future futureToRun() async {
    yetCompleteOrderList = [];
    completeOrderList = [];
    try {
      Map<String, dynamic> data =
          await _ordersServerService.getData(path: "/myOrders");
      List dataList = data['data'];
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

  void navigateToProductDetail(Product product) {
    _analyticsService.logViewItem(
        itemId: product.id,
        itemName: product.name,
        itemCategory: product.category.toString(),
        price: product.price.toDouble(),
        currency: 'won');
    _navigationService.navigateWithTransition(
        ProductDetailView(
          product: product,
        ),
        transition: 'fade');
  }

  Future<void> updateIsReviewedInOrder(String orderId) async {
    await _ordersServerService
        .patchData(path: '/$orderId', data: {"isReviewed": true});
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
        await _reviewsServerService.postData(
            path: "/$productId/reviews/", data: reviewData);
        await updateIsReviewedInOrder(orderId);
        ToastMessageService.showToast(message: "리뷰 작성에 성공하였습니다.");
      } catch (e) {
        ToastMessageService.showToast(message: "리뷰 작성에 실패하였습니다.");
        print(e.toString());
      }
    }
  }
}
