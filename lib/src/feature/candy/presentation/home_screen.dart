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

  /// Хранилище выбора фильтров по местам хранения для группировки по категориям:
  /// ключ - id категории, значение - список id мест хранения
  final Map<String, List<String>> storageFilter = {};

  /// Глобальный фильтр по местам хранения, если категории отключены
  final List<String> globalLocationFilter = [];

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
                      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 4),
                      child: Ink(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(11),
                          gradient: const LinearGradient(
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
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Align(
                                        alignment: Alignment.topLeft,
                                        child: ClipRRect(
                                          borderRadius: const BorderRadius.only(
                                            topRight: Radius.circular(50.50),
                                            bottomRight: Radius.circular(50.50),
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            candy.name,
                                            style: const TextStyle(
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            'location: ${candy.location.name}',
                                            style: const TextStyle(
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            candy.category.name,
                                            style: const TextStyle(
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            candy.expirationDate != null
                                                ? formatDate(candy.expirationDate!)
                                                : 'No expiration',
                                            style: const TextStyle(
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            candy.type.name,
                                            style: const TextStyle(
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
                                      const Gap(5),
                                      SizedBox(
                                        width: 139,
                                        child: Center(
                                          child: Text(
                                            'count: ${candy.quantity}',
                                            style: const TextStyle(
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
                                      const Gap(7),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          AppButton(
                                            color: ButtonColors.pink,
                                            widget: const Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 17,
                                                vertical: 2,
                                              ),
                                              child: Text(
                                                'consume',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Spacer(),
                                          IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () {},
                                            icon: AppIcon(
                                              asset: IconProvider.delete.buildImageUrl(),
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
                        color: const Color(0xFFBB0000),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(11),
                        ),
                      ),
                      child: const Center(
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
        }).toList(),
      ),
    );
  }

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
        globalLocationFilter.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyLoaded) {
          final query = _searchController.text.toLowerCase();
          // Фильтрация
          final filteredCandies = state.candies.where((candy) {
            final matchesName = candy.name.toLowerCase().contains(query);

            // Фильтрация по местам хранения:
            if (_groupByCategory) {
              // Используем storageFilter по категориям
              final categoryId = candy.category.id;
              if (storageFilter.containsKey(categoryId)) {
                final categoryLocations = storageFilter[categoryId]!;
                if (categoryLocations.isEmpty) {
                  return matchesName;
                } else {
                  return matchesName && categoryLocations.contains(candy.location.toString());
                }
              } else {
                return matchesName;
              }
            } else if (_groupByLocation) {
              // Если группировка по категориям выключена, но включена группировка по местам,
              // используем globalLocationFilter
              if (globalLocationFilter.isEmpty) {
                return matchesName;
              } else {
                return matchesName && globalLocationFilter.contains(candy.location.toString());
              }
            } else {
              // Если нет группировки по категориям и нет группировки по местам,
              // фильтр по местам не применяется
              return matchesName;
            }
          }).toList();

          // Группировка
          // По категории и месту хранения
          Map<SweetCategory, Map<StorageLocation, List<Candy>>> filtredGroupedCandys = {};
          for (final candy in filteredCandies) {
            filtredGroupedCandys.putIfAbsent(candy.category, () => {});
            filtredGroupedCandys[candy.category]!.putIfAbsent(candy.location, () => []);
            filtredGroupedCandys[candy.category]![candy.location]!.add(candy);
          }

          // Группировка по категории, если включена
          Map<SweetCategory, List<Candy>> groupedByCategory = {};
          for (final candy in filteredCandies) {
            groupedByCategory.putIfAbsent(candy.category, () => []);
            groupedByCategory[candy.category]!.add(candy);
          }

          // Если группируем по местам без категорий
          Set<StorageLocation> distinctLocations = {};
          if (_groupByLocation && !_groupByCategory) {
            for (var candy in filteredCandies) {
              distinctLocations.add(candy.location);
            }
          }

          return Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 199, top: 16),
                child: SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 16),
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
                      const Gap(5),
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
                            const Spacer(),
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
                                asset: IconProvider.notifications.buildImageUrl(),
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
                          separatorBuilder: (context, index) => const Gap(16),
                          itemCount: filtredGroupedCandys.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = filtredGroupedCandys.keys.elementAt(index);
                            final storageMap = filtredGroupedCandys[category]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок категории
                                Padding(
                                  padding: const EdgeInsets.only(left: 21, right: 21),
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: const TextStyle(
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
                                // Виджеты для выбора места хранения (связаны с категорией)
                                Padding(
                                  padding: const EdgeInsets.only(left: 16, right: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: storageMap.keys.map((storageLocation) {
                                        return buildStorageWidget(
                                          storageName: storageLocation.name,
                                          categoryId: category.id,
                                          locationId: storageLocation.toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const AppDivider(),
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
                          itemCount: groupedByCategory.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = groupedByCategory.keys.elementAt(index);
                            final candies = groupedByCategory[category]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок категории
                                Padding(
                                  padding: const EdgeInsets.only(left: 21, right: 21),
                                  child: Text(
                                    category.name.toUpperCase(),
                                    style: const TextStyle(
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
                                // Нет фильтров по местам без группировки по местам
                                _buildContent(candies),
                              ],
                            );
                          },
                        )
                      else if (_groupByLocation)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 21, right: 21),
                              child: Text(
                                'By Location'.toUpperCase(),
                                style: const TextStyle(
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
                            // Фильтры по местам без категорий
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: distinctLocations.map((loc) {
                                  return buildStorageWidget(
                                    storageName: loc.name,
                                    locationId: loc.name.toLowerCase(),
                                    // categoryId не нужен, тк без категории
                                  );
                                }).toList(),
                              ),
                            ),
                            const AppDivider(),
                            _buildContent(filteredCandies),
                          ],
                        )
                      else
                        // Если нет группировки, просто показываем все
                        _buildContent(filteredCandies),
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
                      context.push("${RouteValue.home.path}/${RouteValue.add.path}");
                    },
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      child: AppIcon(
                        asset: IconProvider.add.buildImageUrl(),
                        width: 29,
                        height: 29,
                      ),
                    ),
                  ),
                ),
              )
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  /// Универсальный виджет фильтра для места хранения.
  /// Если categoryId передан и _groupByCategory = true, фильтруем для этой категории.
  /// Если categoryId не передан или _groupByCategory = false, используем глобальный фильтр.
  Widget buildStorageWidget({required String storageName, String? categoryId, required String locationId}) {
    bool isSelected;
    if (_groupByCategory && categoryId != null) {
      final locations = storageFilter[categoryId] ?? [];
      isSelected = locations.contains(locationId);
    } else {
      // Глобальный фильтр
      isSelected = globalLocationFilter.contains(locationId);
    }

    return AppButton(
      color: isSelected ? ButtonColors.purple : ButtonColors.grey,
      onPressed: () {
        setState(() {
          if (_groupByCategory && categoryId != null) {
            final currentList = storageFilter[categoryId] ?? [];
            if (currentList.contains(locationId)) {
              currentList.remove(locationId);
            } else {
              currentList.add(locationId);
            }
            if (currentList.isEmpty) {
              storageFilter.remove(categoryId);
            } else {
              storageFilter[categoryId] = currentList;
            }
          } else {
            // Глобальный фильтр
            if (globalLocationFilter.contains(locationId)) {
              globalLocationFilter.remove(locationId);
            } else {
              globalLocationFilter.add(locationId);
            }
          }
        });
      },
      widget: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 6, top: 6),
        child: Text(
          storageName,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF790AA3),
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
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  final year = date.year.toString();
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
          gradient: const LinearGradient(
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
