
import 'package:candy_planner/src/feature/candy/model/shopping_item.dart';

import '../../../core/utils/json_loader.dart';


class ShoppingItemRepository {
  final String key = 'shopping_list';

  Future<List<ShoppingItem>> load() {
    return JsonLoader.loadData<ShoppingItem>(
      key,
      'assets/json/$key.json',
      (json) => ShoppingItem.fromMap(json),
    );
  }

  Future<void> save(ShoppingItem item) {
    return JsonLoader.saveData<ShoppingItem>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> remove(ShoppingItem item) {
    return JsonLoader.removeData<ShoppingItem>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> clear() {
    // Очищаем все данные
    return JsonLoader.saveAllData<ShoppingItem>(
      key,
      [],
      (item) => item.toMap(),
    );
  }

  Future<void> saveAll(List<ShoppingItem> items) {
    return JsonLoader.saveAllData<ShoppingItem>(
      key,
      items,
      (item) => item.toMap(),
    );
  }
}
