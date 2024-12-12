import 'package:flutter/cupertino.dart';
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
import 'package:uuid/uuid.dart';

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

  /// Если включена группировка по категориям, используем фильтр storageFilter[categoryId] = [locationId...]
  final Map<String, List<String>> storageFilter = {};

  /// Если отключена группировка по категориям, но включена по местам, используем глобальный фильтр по локациям
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
                      padding:
                          const EdgeInsets.only(left: 4, right: 4, bottom: 4),
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
                                                ? formatDate(
                                                    candy.expirationDate!)
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
                                            onPressed: () =>
                                                showConsumeCandyDialog(
                                                    candy: candy,
                                                    context: context),
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
                                            onPressed: () {
                                              context
                                                  .read<CandyBloc>()
                                                  .add(RemoveCandy(candy));
                                            },
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
                            : CupertinoButton(
                                onPressed: () {
                                  showCandyDialog(
                                      context: context, candy: candy);
                                },
                                padding: EdgeInsets.zero,
                                child: Padding(
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
                      onPressed: () {
                        context.push(
                            "${RouteValue.home.path}/${RouteValue.add.path}",
                            extra: candy);
                      },
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

          // Сначала получим полный список категорий из всех конфет
          final allCategories = <SweetCategory>{};
          final allLocations = <StorageLocation>{};
          for (var candy in state.candies) {
            allCategories.add(candy.category);
            allLocations.add(candy.location);
          }

          // Готовим структуру категорий и мест (без фильтра) для отображения
          Map<SweetCategory, Map<StorageLocation, List<Candy>>> categoryMap =
              {};
          for (var candy in state.candies) {
            categoryMap.putIfAbsent(candy.category, () => {});
            categoryMap[candy.category]!.putIfAbsent(candy.location, () => []);
            categoryMap[candy.category]![candy.location]!.add(candy);
          }

          // Фильтрация по имени и месту хранения
          bool candyMatchesFilter(Candy candy) {
            final matchesName = candy.name.toLowerCase().contains(query);

            if (_groupByCategory) {
              // Используем storageFilter по категориям
              final categoryId = candy.category.id;
              if (storageFilter.containsKey(categoryId)) {
                final categoryLocations = storageFilter[categoryId]!;
                if (categoryLocations.isEmpty) {
                  // Нет выбранных мест для этой категории, значит показываем все
                  return matchesName;
                } else {
                  // Показать только выбранные места
                  return matchesName &&
                      categoryLocations
                          .contains(candy.location.index.toString());
                }
              } else {
                // Для этой категории фильтра нет, показываем все конфеты
                return matchesName;
              }
            } else if (_groupByLocation) {
              // Глобальный фильтр по местам
              if (globalLocationFilter.isEmpty) {
                return matchesName;
              } else {
                return matchesName &&
                    globalLocationFilter
                        .contains(candy.location.index.toString());
              }
            } else {
              // Без фильтра по месту
              return matchesName;
            }
          }

          // Применяем фильтры к каждой категории, чтобы категории не пропадали
          Map<SweetCategory, Map<StorageLocation, List<Candy>>> filteredMap =
              {};
          for (var category in categoryMap.keys) {
            Map<StorageLocation, List<Candy>> locationMap = {};
            for (var location in categoryMap[category]!.keys) {
              final filteredCandies = categoryMap[category]![location]!
                  .where(candyMatchesFilter)
                  .toList();
              if (filteredCandies.isNotEmpty) {
                locationMap[location] = filteredCandies;
              } else {
                // Если хотим, чтобы категория не пропадала и показывалась пустой,
                // можно оставить пустой список.
                // Но лучше показывать категорию даже если нет конфет,
                // значит просто не добавляем locationMap для этого location,
                // и если в итоге будет пусто - категория покажется с пустым контентом.
              }
            }
            filteredMap[category] = locationMap;
          }

          // Для случая без категорий, но с локациями
          // Если не groupByCategory но groupByLocation, покажем глобальный фильтр
          List<Candy> allCandiesFiltered =
              state.candies.where(candyMatchesFilter).toList();
          Set<StorageLocation> distinctLocations = {};
          if (_groupByLocation && !_groupByCategory) {
            for (var candy in allCandiesFiltered) {
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
                              icon: Ink.image(
                                image: AssetImage(
                                  IconProvider.settings.buildImageUrl(),
                                ),
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
                              icon: Ink.image(
                                fit: BoxFit.fitWidth,
                                width: 32,
                                height: 39,
                                image: AssetImage(
                                  IconProvider.notifications.buildImageUrl(),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (state.candies.isEmpty)
                        Center(
                          child: Padding(
                            padding:
                                EdgeInsets.only(top: getHeight(0.3, context)),
                            child: Text(
                              'No candies here!',
                              style: TextStyle(
                                fontSize: 27,
                                fontFamily: 'Boleh',
                                fontWeight: FontWeight.w400,
                                height: 0,
                                shadows: [
                                  Shadow(
                                    offset: Offset(2, 2),
                                    blurRadius: 4,
                                    color: Colors.black.withOpacity(0.25),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (_groupByCategory && _groupByLocation)
                        // Отображаем категории и их места
                        ListView.separated(
                          separatorBuilder: (context, index) => const Gap(16),
                          itemCount: filteredMap.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = filteredMap.keys.elementAt(index);
                            final storageMap = filteredMap[category]!;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Заголовок категории
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 21, right: 21),
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
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: (categoryMap[category]!.keys)
                                          .map((storageLocation) {
                                        return buildStorageWidget(
                                          storageName: storageLocation.name,
                                          categoryId: category.id,
                                          locationId:
                                              storageLocation.index.toString(),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                                const AppDivider(),
                                // Отображаем отфильтрованные конфеты для этой категории
                                // Если пусто - покажем просто пустое место
                                _buildContent(storageMap.values
                                    .expand((x) => x)
                                    .toList()),
                              ],
                            );
                          },
                        )
                      else if (_groupByCategory)
                        ListView.separated(
                          separatorBuilder: (context, index) => const Gap(16),
                          itemCount: filteredMap.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final category = filteredMap.keys.elementAt(index);
                            final storageMap = filteredMap[category]!;
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
                              padding:
                                  const EdgeInsets.only(left: 21, right: 21),
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
                                children: allLocations.map((loc) {
                                  return buildStorageWidget(
                                    storageName: loc.name,
                                    locationId: loc.index.toString(),
                                  );
                                }).toList(),
                              ),
                            ),
                            const AppDivider(),
                            _buildContent(allCandiesFiltered),
                          ],
                        )
                      else
                        // Если нет группировки, просто показываем все
                        _buildContent(allCandiesFiltered),
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
                      showTemplateSelectionDialog(
                        context: context,
                        templates: state.candies
                            .where((test) => test.isTemplate)
                            .toList(),
                      );
                    },
                    widget: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 10),
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

  Widget buildStorageWidget(
      {required String storageName,
      String? categoryId,
      required String locationId}) {
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
            // Глобальный фильтр для мест
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

Future<int?> showConsumeCandyDialog({
  required BuildContext context,
  required Candy candy,
}) async {
  int currentValue = 1; // начальное значение

  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Consume Candies'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (currentValue > 1) {
                  currentValue--;
                  (context as Element).markNeedsBuild();
                }
              },
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: 'Count',
                  border: const OutlineInputBorder(),
                ),
                controller:
                    TextEditingController(text: currentValue.toString()),
                onChanged: (value) {
                  final intVal = int.tryParse(value);
                  if (intVal != null &&
                      intVal >= 1 &&
                      intVal <= candy.quantity) {
                    currentValue = intVal;
                  } else if (intVal != null && intVal > candy.quantity) {
                    currentValue = candy.quantity;
                    (context as Element).markNeedsBuild();
                  } else if (intVal != null && intVal < 1) {
                    currentValue = 1;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                if (currentValue < candy.quantity) {
                  currentValue++;
                  (context as Element).markNeedsBuild();
                }
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop(); // Отмена
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (candy.quantity - currentValue > 0) {
                context.read<CandyBloc>().add(UpdateCandy(
                    candy.copyWith(quantity: candy.quantity - currentValue)));
              } else {
                context.read<CandyBloc>().add(RemoveCandy(candy));
              }

              context.pop(); // Отмена
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<String?> showTemplateSelectionDialog({
  required BuildContext context,
  required List<Candy> templates,
}) async {
  // Если нет шаблонов
  if (templates.isEmpty) {
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('No Templates'),
          content: const Text('There are no candy templates available.'),
          actions: [
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                context.pop();
                context.push("${RouteValue.home.path}/${RouteValue.add.path}");
              },
              child: const Text('Create'),
            ),
          ],
        );
      },
    );
  }

  // Есть шаблоны
  String? selectedTemplateId;
  return showDialog<String>(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Select Template'),
            content: SizedBox(
              width: double.minPositive,
              height: 200,
              child: ListView(
                children: templates.map((tmpl) {
                  return RadioListTile<String>(
                    title: Text(tmpl.name),
                    value: tmpl.id,
                    groupValue: selectedTemplateId,
                    onChanged: (value) {
                      setState(() {
                        selectedTemplateId = value;
                        (context as Element).markNeedsBuild();
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  context.pop();
                },
                child: const Text('Cancel'),
              ),
              if (selectedTemplateId == null)
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    context
                        .push("${RouteValue.home.path}/${RouteValue.add.path}");
                  },
                  child: const Text('Create'),
                )
              else
                ElevatedButton(
                  onPressed: () {
                    context.pop();
                    showAddFromTemplateDialog(
                        context: context,
                        template: templates.firstWhere(
                            (element) => element.id == selectedTemplateId));
                  },
                  child: const Text('OK'),
                ),
            ],
          );
        },
      );
    },
  );
}

/// Диалог для ввода количества конфет при добавлении из шаблона
Future<int?> showAddFromTemplateDialog({
  required BuildContext context,
  required Candy template,
}) async {
  int currentValue = 1;

  return showDialog<int>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Add candies from template "${template.name}"'),
        content: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: () {
                if (currentValue > 1) {
                  currentValue--;
                  (context as Element).markNeedsBuild();
                }
              },
              icon: const Icon(Icons.remove),
            ),
            Expanded(
              child: TextField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                  hintText: 'Count',
                  border: OutlineInputBorder(),
                ),
                controller:
                    TextEditingController(text: currentValue.toString()),
                onChanged: (value) {
                  final intVal = int.tryParse(value);
                  if (intVal != null && intVal >= 1) {
                    currentValue = intVal;
                  } else {
                    currentValue = 1;
                    (context as Element).markNeedsBuild();
                  }
                },
              ),
            ),
            IconButton(
              onPressed: () {
                // Нет верхнего ограничения, можно при желании добавить
                currentValue++;
                (context as Element).markNeedsBuild();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pop();
              context.read<CandyBloc>().add(SaveCandy(template.copyWith(
                    quantity: currentValue,
                    id: const Uuid().v4(),
                  )));
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<void> showCandyDialog(
    {required BuildContext context, required Candy candy}) async {
  await showDialog(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text('Candy: ${candy.name}'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${candy.category.name}'),
            Text('Location: ${candy.location.name}'),
            Text('Quantity: ${candy.quantity}'),
            Text(
                'Expiration Date: ${candy.expirationDate != null ? formatDate(candy.expirationDate!)  : 'N/A'}'),
          ],
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            child: const Text('Consume'),
            onPressed: () {
              showConsumeCandyDialog(candy: candy, context: context);
              context.pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Edit'),
            onPressed: () {
              context.push("${RouteValue.home.path}/${RouteValue.add.path}",
                  extra: candy);
              context.pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Delete'),
            onPressed: () {
              context.read<CandyBloc>().add(RemoveCandy(candy));
              context.pop();
            },
          ),
          CupertinoDialogAction(
            child: const Text('Cancel'),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      );
    },
  );
}
