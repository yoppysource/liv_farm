// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/analytics_service.dart';
import '../services/cart_provider_service.dart';
import '../services/secure_storage_service.dart';
import '../services/user_provider_service.dart';
import '../ui/home/farm/farm_viewmodel.dart';
import '../ui/home/shopping_cart/shopping_cart_viewmodel.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => UserProviderService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => CartProviderService());
  locator.registerSingleton(SecureStorageService());
  locator.registerSingleton(FarmViewModel());
  locator.registerSingleton(ShoppingCartViewModel());
}
