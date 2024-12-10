import 'package:get_it/get_it.dart';
import 'package:sweet_planner/src/feature/candy/repository/history_repository.dart';
import 'package:sweet_planner/src/feature/candy/repository/repository.dart';
import 'package:sweet_planner/src/feature/candy/repository/shop_repository.dart';

final locator = GetIt.instance;

void setupDependencyInjection() {
  locator.registerLazySingleton(()=>UsageHistoryRepository());
  locator.registerLazySingleton<CandyRepository>(() => CandyRepository());
  locator.registerLazySingleton<ShoppingItemRepository>(() => ShoppingItemRepository());

 }
