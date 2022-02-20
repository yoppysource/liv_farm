import 'package:liv_farm/services/analytics_service.dart';
import 'package:liv_farm/services/cart_provider_service.dart';
import 'package:liv_farm/services/dynamic_link_service.dart';
import 'package:liv_farm/services/location_service.dart';
import 'package:liv_farm/services/secure_storage_service.dart';
import 'package:liv_farm/services/server_service/client_service.dart';
import 'package:liv_farm/services/store_provider_service.dart';
import 'package:liv_farm/services/user_provider_service.dart';
import 'package:liv_farm/ui/auth/login/login_view.dart';
import 'package:liv_farm/ui/auth/signup/signup_view.dart';
import 'package:liv_farm/ui/home/coupon/coupon_view.dart';
import 'package:liv_farm/ui/home/farm/online_farm/online_farm_viewmodel.dart';
import 'package:liv_farm/ui/home/farm/product_detail/product_detail_view.dart';
import 'package:liv_farm/ui/home/home_main/event_banner/event_banner_view.dart';
import 'package:liv_farm/ui/home/home_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_option_view.dart';
import 'package:liv_farm/ui/home/shopping_cart/purchase/purchase_view.dart';
import 'package:liv_farm/ui/home/video/video_view.dart';
import 'package:liv_farm/ui/landing/landing_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(routes: [
  MaterialRoute(page: LandingView, initial: true),
  CupertinoRoute(page: LoginView),
  CupertinoRoute(page: SignupView),
  CupertinoRoute(page: ProductDetailView, fullscreenDialog: true),
  CupertinoRoute(page: HomeView),
  CupertinoRoute(page: PurchaseView),
  CupertinoRoute(page: CouponView),
  CupertinoRoute(page: PurchaseOptionView),
  CupertinoRoute(page: VideoView)
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: UserProviderService),
  LazySingleton(classType: DialogService),
  LazySingleton(classType: BottomSheetService),
  LazySingleton(classType: AnalyticsService),
  LazySingleton(classType: CartProviderService),
  LazySingleton(classType: StoreProviderService),
  LazySingleton(classType: LocationService),
  LazySingleton(classType: DynamicLinkService),
  LazySingleton(classType: OnlineFarmViewModel),
  LazySingleton(classType: EventBannerViewModel),
  Singleton(classType: SecureStorageService),
  Singleton(classType: ClientService),
])
class AppSetup {}
