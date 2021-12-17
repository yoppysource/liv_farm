// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../services/analytics_service.dart';
import '../services/cart_provider_service.dart';
import '../services/dynamic_link_service.dart';
import '../services/in_offine_store_service.dart';
import '../services/location_service.dart';
import '../services/secure_storage_service.dart';
import '../services/server_service/server_service.dart';
import '../services/store_provider_service.dart';
import '../services/user_provider_service.dart';

final locator = StackedLocator.instance;

void setupLocator() {
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => UserProviderService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => AnalyticsService());
  locator.registerLazySingleton(() => CartProviderService());
  locator.registerLazySingleton(() => StoreProviderService());
  locator.registerLazySingleton(() => LocationService());
  locator.registerLazySingleton(() => DynamicLinkService());
  locator.registerLazySingleton(() => InOffineStoreService());
  locator.registerSingleton(SecureStorageService());
  locator.registerSingleton(ServerService());
}
