import 'package:candy_planner/src/feature/candy/model/candy.dart';

import '../../../core/utils/json_loader.dart';

class CandyRepository {
  final String key = 'candy';

  Future<List<Candy>> load() {
    return JsonLoader.loadData<Candy>(
      key,
      'assets/json/$key.json',
      (json) => Candy.fromMap(json),
    );
  }

  Future<void> update(Candy updated) async {
    return JsonLoader.modifyDataList<Candy>(
      key,
      updated,
      () async => await load(),
      (item) => item.toMap(),
      (itemList) async {
        final index = itemList.indexWhere((d) => d.id == updated.id);
        if (index != -1) {
          itemList[index] = updated;
        }
      },
    );
  }

  Future<void> save(Candy item) {
    return JsonLoader.saveData<Candy>(
      key,
      item,
      () async => await load(),
      (item) => item.copyWith().toMap(),
    );
  }

  Future<void> remove(Candy item) {
    return JsonLoader.removeData<Candy>(
      key,
      item,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<Candy?> getById(int id) async {
    final candys = await load();
    return candys.firstWhere(
      (candy) => candy.id == id,
    );
  }

  // Добавляем метод saveAll
  Future<void> saveAll(List<Candy> candys) {
    return JsonLoader.saveAllData<Candy>(
      key,
      candys,
      (item) => item.toMap(),
    );
  }
}
