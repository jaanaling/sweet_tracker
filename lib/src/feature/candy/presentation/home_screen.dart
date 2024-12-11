import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:sweet_planner/routes/go_router_config.dart';
import 'package:sweet_planner/routes/route_value.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/storage_location.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';
import 'package:sweet_planner/ui_kit/app_button/app_button.dart';
import 'package:sweet_planner/ui_kit/text_field.dart';

enum HomeDisplayMode {
  fullDetails,
  groupByCategory,
  groupByLocation,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _groupByCategory = true;
  bool _groupByLocation = true;
  bool _showFullDetails = false;
  final TextEditingController _searchController = TextEditingController();
  final Map<SweetCategory, List<String>> storageFilter = {};

  /// Построение контента для списка конфет
  Widget _buildContent(List<Candy> candies) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Wrap(
          spacing: 15,
          runSpacing: 15,
          children: candies.map((candy) {
            return Padding(
              padding: const EdgeInsets.only(top: 9, right: 6),
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 9, right: 6),
                    child: AppButton(
                      color: ButtonColors.darkPurple,
                      radius: 11,
                      widget: Padding(
                        padding:
                            const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(11),
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Colors.white, Color(0xFFCDDAE8)],
                            ),
                          ),
                          child: _showFullDetails
                              ? SizedBox(
                                  width: 155,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 17),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Align(
                                          alignment: Alignment.topLeft,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(50.50),
                                              bottomRight:
                                                  Radius.circular(50.50),
                                            ),
                                            child: AppIcon(
                                              width: 128,
                                              height: 72,
                                              fit: BoxFit.cover,
                                              asset: candy.imageUrl ??
                                                  IconProvider.buildImageByName(
                                                    candy.type.name,
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              candy.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w500,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              'location: ${candy.location.name}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              candy.category.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              candy.expirationDate != null
                                                  ? formatDate(
                                                      candy.expirationDate!)
                                                  : 'No expiration',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              candy.type.name,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        SizedBox(
                                          width: 139,
                                          child: Center(
                                            child: Text(
                                              'count: ${candy.quantity}',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 14,
                                                fontFamily: 'Poppins',
                                                fontWeight: FontWeight.w300,
                                                height: 0,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                        Gap(7),
                                        Row(
                                          children: [
                                            Spacer(),
                                            AppButton(
                                                color: ButtonColors.pink,
                                                widget: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 17,
                                                      vertical: 2),
                                                  child: Text(
                                                    'consume',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontFamily: 'Poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      height: 0,
                                                    ),
                                                  ),
                                                )),
                                            Spacer(),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              onPressed: () {},
                                              icon: AppIcon(
                                                asset: IconProvider.delete
                                                    .buildImageUrl(),
                                                width: 20,
                                                fit: BoxFit.fitWidth,
                                                height: 24,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: AppIcon(
                                      width: 86,
                                      height: 86,
                                      fit: BoxFit.cover,
                                      asset: candy.imageUrl ??
                                          IconProvider.buildImageByName(
                                            candy.type.name,
                                          ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  if (candy.expirationDate != null &&
                      DateTime.now().isAfter(candy.expirationDate!))
                    Positioned(
                      right: 0,
                      top: 0,
                      child: Container(
                        width: 67,
                        height: 22,
                        decoration: ShapeDecoration(
                          color: Color(0xFFBB0000),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(11),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'expired',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w400,
                              height: 0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (_showFullDetails)
                    Positioned(
                      top: 15,
                      left: 5,
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {},
                        icon: AppIcon(
                          asset: IconProvider.edit.buildImageUrl(),
                          width: 21,
                          fit: BoxFit.fitWidth,
                          height: 21,
                        ),
                      ),
                    ),
                ],
              ),
            );
          }).toList()),
    );
  }

  /// Отображение всплывающего меню настроек
  void _showSettingsPopup() async {
    final result = await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(100, 100, 0, 0),
      items: [
        CheckedPopupMenuItem(
          value: 'location',
          checked: _groupByLocation,
          child: const Text('Storage Location'),
        ),
        CheckedPopupMenuItem(
          value: 'category',
          checked: _groupByCategory,
          child: const Text('Category'),
        ),
        CheckedPopupMenuItem(
          value: 'fullDetails',
          checked: _showFullDetails,
          child: const Text('Full details'),
        ),
      ],
    );

    if (result != null) {
      setState(() {
        if (result == 'location') {
          _groupByLocation = !_groupByLocation;
        } else if (result == 'category') {
          _groupByCategory = !_groupByCategory;
        } else if (result == 'fullDetails') {
          _showFullDetails = !_showFullDetails;
        }
        storageFilter.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyLoaded) {
          // Объединенная фильтрация по имени и месту хранения
          final List<Candy> filteredCandys = state.candies.where((candy) {
            // Фильтрация по имени конфеты
            bool matchesName = candy.name
                .toLowerCase()
                .contains(_searchController.text.toLowerCase());

            // Фильтрация по месту хранения (местоположению) для категории
            bool matchesLocation = false;
            if (storageFilter.containsKey(candy.category)) {
              final categoryFilter = storageFilter[candy.category]!;
              if (categoryFilter.isEmpty) {
                matchesLocation =
                    true; // Если фильтр пустой, пропускаем местоположение
              } else {
                // Проверка, если местоположение конфеты входит в фильтр
                matchesLocation =
                    categoryFilter.contains(candy.location.name) ||
                        categoryFilter.contains(candy.location.name);
              }
            } else {
              matchesLocation =
                  true; // Если нет фильтра для категории, пропускаем местоположение
            }

            // Возвращаем конфету, если она проходит оба фильтра
            return matchesName && matchesLocation;
          }).toList();

          // Группируем отфильтрованные конфеты по категории и месту хранения
          final filtredGropedCandys =
              <SweetCategory, Map<StorageLocation, List<Candy>>>{};
          for (final candy in filteredCandys) {
            filtredGropedCandys.putIfAbsent(candy.category, () => {});
            filtredGropedCandys[candy.category]
                ?.putIfAbsent(candy.location, () => [])
                .add(candy);
          }
          final groupedCandys = <SweetCategory, List<Candy>>{};
          for (final candy in filteredCandys) {
            groupedCandys.putIfAbsent(candy.category, () => []).add(candy);
          }
          // Вывод отладочной информации
          print('Filtered candies: $filteredCandys');
          print('Grouped candies: $groupedCandys');
          print('Filtered grouped candies: $filtredGropedCandys');
          print('Storage filter: $storageFilter');

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 199, top: 16),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Text(
                          'Home page',
                          style: TextStyle(
                            color: Color(0xFF540073),
                            fontSize: 25,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w300,
                            height: 0,
                          ),
                        ),
                      ),
                      Gap(5),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            SearchTextField(
                              controller: _searchController,
                              onChanged: () {
                                setState(() {});
                              },
                            ),
                            Spacer(),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: _showSettingsPopup,
                              icon: AppIcon(
                                asset: IconProvider.settings.buildImageUrl(),
                                width: 39,
                                fit: BoxFit.fitWidth,
                                height: 42,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                context.push(
                                  "${RouteValue.home.path}/${RouteValue.notification.path}",
                                );
                              },
                              icon: AppIcon(
                                asset:
                                    IconProvider.notifications.buildImageUrl(),
                                fit: BoxFit.fitWidth,
                                width: 32,
                                height: 39,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (_groupByCategory && _groupByLocation)
                        ListView.separated(
                          separatorBuilder: (context, index) => Gap(16),
                          itemCount: filtredGropedCandys.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category =
                                filtredGropedCandys.keys.elementAt(index);
                            final storageMap =
                                filtredGropedCandys.values.elementAt(index);

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок категории
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 21, right: 21),
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Cygre Black',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(4),
                                // Виджеты для выбора места хранения
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...storageMap.keys
                                            .map(
                                              (storageLocation) =>
                                                  storageWidget(
                                                storageLocation.name,
                                                category,
                                                storageLocation.name,
                                              ),
                                            )
                                            .toList(),
                                      ],
                                    ),
                                  ),
                                ),
                                AppDivider(),
                                // Отображение конфет
                                _buildContent(
                                  storageMap.values.expand((x) => x).toList(),
                                ),
                              ],
                            );
                          },
                        )
                      else if (_groupByCategory)
                        ListView.separated(
                          separatorBuilder: (context, index) => const Gap(16),
                          itemCount: filtredGropedCandys.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category =
                                filtredGropedCandys.keys.elementAt(index);
                            final storageMap =
                                filtredGropedCandys.values.elementAt(index);

                            // Получаем все конфеты для данной категории
                            final candies =
                                storageMap.values.expand((x) => x).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок категории
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 21, right: 21),
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontFamily: 'Cygre Black',
                                      fontWeight: FontWeight.w900,
                                      height: 0,
                                      shadows: [
                                        Shadow(
                                          offset: Offset(2, 2),
                                          blurRadius: 4,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Gap(4),
                                // Отображение конфет
                                _buildContent(candies),
                              ],
                            );
                          },
                        )
                      else if (_groupByLocation)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Заголовок категории

                            // Виджеты для выбора места хранения
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: [
                                  ...groupedCandys.values
                                      .expand((x) => x)
                                      .toList()
                                      .map(
                                        (storageLocation) => storageWidget(
                                          storageLocation.location.name,
                                          storageLocation.category,
                                          storageLocation.location.name,
                                        ),
                                      )
                                      .toList(),
                                ],
                              ),
                            ),
                            AppDivider(),
                            // Отображение конфет
                            _buildContent(
                              groupedCandys.values.expand((x) => x).toList(),
                            ),
                          ],
                        )
                      else
                        // Если нет группировки, отображаем все конфеты
                        Expanded(
                          child: _buildContent(filteredCandys),
                        ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 128,
                right: 23,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: AppButton(
                      radius: 10,
                      color: ButtonColors.pink,
                      onPressed: () {
                        context.push(
                            "${RouteValue.home.path}/${RouteValue.add.path}");
                      },
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 10),
                        child: AppIcon(
                          asset: IconProvider.add.buildImageUrl(),
                          width: 29,
                          height: 29,
                        ),
                      )),
                ),
              )
            ],
          );
        }
        // Если состояние не загружено, показываем индикатор загрузки
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Виджет для выбора места хранения
  AppButton storageWidget(String storage, SweetCategory category, String id) {
    final bool isSelected = storageFilter.containsValue(storage);
    return AppButton(
      color: isSelected ? ButtonColors.purple : ButtonColors.grey,
      onPressed: () {
        setState(() {
          if (storageFilter[category] == null) {
            storageFilter[category ?? SweetCategory(id: id, name: storage)] = [
              id,
            ];
          } else if (storageFilter[category]!.contains(id)) {
            storageFilter[category]!.remove(id);
          } else {
            storageFilter[category]!.add(id);
          }
        });
      },
      widget: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 6, top: 6),
        child: Text(
          storage,
          style: TextStyle(
            color: isSelected ? Colors.white : Color(0xFF790AA3),
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
            height: 0,
          ),
        ),
      ),
    );
  }
}

String formatDate(DateTime date) {
  String month = date.month.toString().padLeft(2, '0');
  String day = date.day.toString().padLeft(2, '0');
  String year = date.year.toString();
  return '$month.$day.$year';
}

class AppDivider extends StatelessWidget {
  const AppDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Container(
        width: getWidth(1, context) - 16,
        height: 2,
        decoration: ShapeDecoration(
          gradient: LinearGradient(
            begin: Alignment(1.00, 0.00),
            end: Alignment(-1, 0),
            colors: [Color(0x00881CB8), Color(0xFF881CB8), Color(0x00881CB8)],
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }
}
