import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/auth/login/login_view.dart';
import 'package:liv_farm/ui/auth/signup/signup_view.dart';
import 'package:liv_farm/ui/home/coupon/coupon_view.dart';
import 'package:liv_farm/ui/home/farm/farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:liv_farm/ui/home/home_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/shopping_cart_viewmodel.dart';
import 'package:liv_farm/ui/home/video/video_view.dart';
import 'package:liv_farm/ui/landing/landing_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: LandingView, initial: true),
  CupertinoRoute(page: LoginView),
  CupertinoRoute(page: SignupView),
  CupertinoRoute(page: VideoView),
  CupertinoRoute(page: ProductDetailView, fullscreenDialog: true),
  CupertinoRoute(page: HomeView),
  CupertinoRoute(page: PurchaseView),
  CupertinoRoute(page: CouponView),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: UserProviderService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: AnalyticsService),
  LazySingleton(classType: CartProviderService),
  Singleton(classType: SecureStorageService),
  Singleton(classType: FarmViewModel),
  Singleton(classType: ShoppingCartViewModel)
])
class AppSetup {}
