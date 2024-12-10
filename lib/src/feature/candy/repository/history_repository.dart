import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/history.dart';

import '../../../core/utils/json_loader.dart';

class UsageHistoryRepository {
  final String key = 'usage_history';

  Future<List<UsageHistoryRecord>> load() {
    return JsonLoader.loadData<UsageHistoryRecord>(
      key,
      'assets/json/$key.json',
      (json) => UsageHistoryRecord.fromMap(json),
    );
  }

  Future<void> addRecord(UsageHistoryRecord record) async {
    return JsonLoader.saveData<UsageHistoryRecord>(
      key,
      record,
      () async => await load(),
      (item) => item.toMap(),
    );
  }

  Future<void> saveAll(List<UsageHistoryRecord> records) {
    return JsonLoader.saveAllData<UsageHistoryRecord>(
      key,
      records,
      (item) => item.toMap(),
    );
  }
}
