import 'package:get_it/get_it.dart';
import 'package:liv_farm/service/analytic_service.dart';
import 'package:liv_farm/service/root_navigation_service.dart';
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() =>AnalyticsService());
}