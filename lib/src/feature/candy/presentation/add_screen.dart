import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/storage_location.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';
import 'package:sweet_planner/src/feature/candy/presentation/home_screen.dart';
import 'package:sweet_planner/ui_kit/app_button/app_button.dart';
import 'package:sweet_planner/ui_kit/text_field.dart';
import 'package:uuid/uuid.dart';

class AddSweetScreen extends StatefulWidget {
  final Candy? candy;
  final bool? isShop;
  const AddSweetScreen({Key? key, this.candy, this.isShop}) : super(key: key);

  @override
  State<AddSweetScreen> createState() => _AddSweetScreenState();
}

class _AddSweetScreenState extends State<AddSweetScreen> {
  final List<String> weekDays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usageCategoryController = TextEditingController();
  TextEditingController selectedPeriodicityCount = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  final _controller00 = ValueNotifier<bool>(false);
  final _controller01 = ValueNotifier<bool>(false);
  final _controller02 = ValueNotifier<bool>(false);

  String? selectedImage;
  String? selectedLocation;
  String? selectedCategory;

  DateTime selectedExpirationDate = DateTime.now();

  List<int> selectedDates = [];

  bool recurringCandy = false;
  bool saveTemplate = false;
  bool addToCart = false;

  @override
  void initState() {
    super.initState();
    if (widget.candy != null) {
      _nameController.text = widget.candy!.name;
      _usageCategoryController.text = widget.candy!.category.name;
      quantityController.text = widget.candy!.quantity.toString();
      selectedExpirationDate = widget.candy!.expirationDate ?? DateTime.now();
      selectedLocation = widget.candy!.location.name;
      selectedCategory = widget.candy!.type.name;
      recurringCandy = widget.candy!.isPermanent;
      saveTemplate = widget.candy!.isTemplate;
      selectedDates = widget.candy!.periodicityDays ?? [];
      selectedPeriodicityCount.text = widget.candy!.periodicityCount.toString();
      selectedImage = widget.candy!.imageUrl;
      _controller00.value = widget.candy!.isPermanent;
      _controller01.value = widget.candy!.isTemplate;
    }
    if (widget.isShop != null) {
      addToCart = widget.isShop!;
      _controller02.value = widget.isShop!;
    }
  }

  // Поле для ввода текста
  Widget _buildTextField({
    required String label,
    required List<String> hints,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Autocomplete<String>(
            optionsBuilder: (TextEditingValue textEditingValue) {
              // Фильтруем список подсказок на основе введенного текста
              return hints.where((suggestion) {
                return suggestion
                    .toLowerCase()
                    .contains(textEditingValue.text.toLowerCase());
              }).toList();
            },
            onSelected: (String selection) {
              // Когда пользователь выбирает подсказку
              print('Выбрано: $selection');
              controller.text = selection;
            },
            fieldViewBuilder:
                (context, controlller, focusNode, onEditingComplete) {
              return TextField(
                onChanged: (value) => setState(() {
                  controller.text = value;
                }),
                controller: controlller,
                focusNode: focusNode,
                decoration: const InputDecoration(
                  hintText: 'Введите название конфеты',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onEditingComplete: onEditingComplete,
              );
            },
          ),
        ),
      ],
    );
  }

  // Выпадающий список (категория, место хранения)
  Widget _buildDropdown(
      {required String label,
      required List<String> options,
      String? initial,
      required ValueChanged<String?>? onChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
            isExpanded: true,
            value: initial,
            items: options.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: onChanged),
      ],
    );
  }

  // Переключатели (свитчи)
  Widget _buildSwitch(
      {required String label,
      required bool initial,
      required ValueNotifier<bool> controller,
      required void Function(dynamic) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(left: 22, right: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Color(0xFF790AA3),
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
          AdvancedSwitch(
            initialValue: initial,
            controller: controller,
            activeColor: const Color(0xFF29D58B),
            inactiveColor: const Color(0xFFD52974),
            activeChild: const Text(
              'ON',
              style: TextStyle(
                color: Color(0xFF790AA3),
                fontSize: 20,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
              ),
            ),
            inactiveChild: const Text('OFF',
                style: TextStyle(
                  color: Color(0xFF790AA3),
                  fontSize: 20,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w300,
                )),
            activeImage: const AssetImage(
              'assets/images/on_background.png',
            ),
            inactiveImage: const AssetImage('assets/images/on_background.png'),
            onChanged: onChanged,
            borderRadius: const BorderRadius.all(Radius.circular(24.5)),
            thumb: ValueListenableBuilder<bool>(
              valueListenable: controller,
              builder: (_, value, __) {
                return Image.asset(
                  value ? 'assets/images/on.png' : 'assets/images/off.png',
                  width: 45,
                  height: 45,
                );
              },
            ),
            width: 107,
            height: 49,
          ),
        ],
      ),
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Choose expiration date'),
          message: SizedBox(
            height:
                200, // Set height to allow for the date picker to be visible
            child: CupertinoDatePicker(
              initialDateTime: selectedExpirationDate,
              minimumDate: DateTime(2000),
              maximumDate: DateTime(2101),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedExpirationDate = newDate; // Update the selected date
                });
              },
              mode: CupertinoDatePickerMode.date, // Use the date picker mode
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              context.pop(); // Close the popup
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();

    // Pick an image from the gallery
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path; // Store the picked image
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Экран с формой добавления сладости
    return BlocBuilder<CandyBloc, CandyState>(
      builder: (context, state) {
        if (state is CandyError) {
          return const Center(child: Text('Error'));
        }
        if (state is CandyLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is CandyLoaded) {
          final Set<String> candiesHint =
              state.candies.map((e) => e.name).toSet()
                ..addAll(state.historyList.map((e) => e.sweetName).toSet())
                ..addAll(state.shoppingList.map((e) => e.candy.name).toSet());
          final Set<SweetCategory> categoriesHint = state.candies
              .map((e) => e.category)
              .toSet()
            ..addAll(state.historyList.map((e) => e.category).toSet())
            ..addAll(state.shoppingList.map((e) => e.candy.category).toSet());

          return SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 128, top: 16),
            child: SafeArea(
              child: Material(
                color: Colors.transparent,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: AppButton(
                              radius: 11,
                              color: ButtonColors.white,
                              onPressed: _pickImage,
                              widget: SizedBox(
                                width: 121.93,
                                height: 123,
                                child: Center(
                                  child: selectedImage == null
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              left: 20.32,
                                              right: 28.98,
                                              bottom: 33.16,
                                              top: 19.53),
                                          child: AppIcon(
                                            asset: IconProvider.addPhoto
                                                .buildImageUrl(),
                                            width: 72.63,
                                            height: 66.31,
                                            fit: BoxFit.fitWidth,
                                          ),
                                        )
                                      : Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 4),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(7),
                                            child: Image.file(
                                              width: 121.93 - 16,
                                              height: 123 - 12,
                                              File(
                                                  selectedImage!), // Show the selected image
                                              fit: BoxFit
                                                  .cover, // Ensure the image fits well inside the container
                                            ),
                                          ),
                                        ),
                                ),
                              )),
                        ),
                        const Gap(17),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppTextField(
                              height: 52,
                              width: getWidth(1, context) - 121.93 - 58,
                              controller: _nameController,
                              placeholder: 'Name',
                              hints: candiesHint.toList(),
                            ),
                            const Gap(14),
                            AppButton(
                              color: ButtonColors.grey,
                              widget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 8,
                                ),
                                child: SizedBox(
                                  width: getWidth(0.372, context),
                                  child: const Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        'category',
                                        style: TextStyle(
                                          color: Color(0xFF790AA3),
                                          fontSize: 16,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          height: 0,
                                        ),
                                      ),
                                      Spacer(),
                                      Gap(8),
                                      Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Color(0x91790AA3),
                                      ),
                                      Gap(10)
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const Gap(13),
                    Row(
                      children: [
                        const Gap(16),
                        AppButton(
                          color: ButtonColors.grey,
                          widget: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                            ),
                            child: SizedBox(
                              width: getWidth(1, context) / 2 - 20.5,
                              child: const Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    'storage\nlocation',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF790AA3),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.07,
                                    ),
                                  ),
                                  Spacer(),
                                  Gap(8),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0x91790AA3),
                                  ),
                                  Gap(10)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(9),
                        AppButton(
                          color: ButtonColors.grey,
                          onPressed: () => _showDatePicker(context),
                          widget: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                            ),
                            child: SizedBox(
                              width: getWidth(1, context) / 2 - 20.5,
                              child: const Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    'expiration\ndate',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF790AA3),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.07,
                                    ),
                                  ),
                                  Spacer(),
                                  Gap(8),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0x91790AA3),
                                  ),
                                  Gap(10)
                                ],
                              ),
                            ),
                          ),
                        ),
                        const Gap(16)
                      ],
                    ),
                    const Gap(13),
                    AppTextField(
                        height: 52,
                        borderRadius: 11,
                        width: getWidth(1, context) - 32,
                        controller: _usageCategoryController,
                        placeholder: 'Usage category',
                        hints: categoriesHint.map((e) => e.name).toList()),
                    const Gap(13),
                    const SizedBox(height: 16),

                    _buildTextField(
                        label: 'Name',
                        hints: candiesHint.toList(),
                        controller: _nameController),
                    const SizedBox(height: 16),

                    _buildTextField(
                        label: 'Quantity',
                        hints: [],
                        controller: quantityController),
                    const SizedBox(height: 16),
                    _buildDropdown(
                        label: 'Category',
                        options: SweetType.values.map((e) => e.name).toList(),
                        initial: selectedCategory,
                        onChanged: (val) {
                          setState(() {
                            selectedCategory = val;
                          });
                        }),
                    const SizedBox(height: 16),

                    _buildDropdown(
                        label: 'Storage location',
                        options:
                            StorageLocation.values.map((e) => e.name).toList(),
                        initial: selectedLocation,
                        onChanged: (val) {
                          setState(() {
                            selectedLocation = val;
                          });
                        }),
                    const SizedBox(height: 16),

                    ElevatedButton(
                        onPressed: () => _showDatePicker(context),
                        child: const Text('Select expiration date')),
                    const SizedBox(height: 16),

                    _buildTextField(
                        label: 'Usage category',
                        hints: categoriesHint.map((e) => e.name).toList(),
                        controller: _usageCategoryController),
                    const SizedBox(height: 16),

                    _buildSwitch(
                        label: 'Recurring candy',
                        initial: recurringCandy,
                        controller: _controller00,
                        onChanged: (val) {
                          setState(() {
                            recurringCandy = val as bool;
                          });
                        }),
                    AppDivider(),
                    Gap(10),
                    _buildSwitch(
                        label: 'Save template',
                        initial: saveTemplate,
                        controller: _controller01,
                        onChanged: (val) {
                          setState(() {
                            saveTemplate = val as bool;
                          });
                        }),
                    AppDivider(),
                    Gap(10),
                    _buildSwitch(
                        label: 'Auto-add to cart',
                        initial: addToCart,
                        controller: _controller02,
                        onChanged: (val) {
                          setState(() {
                            addToCart = val as bool;
                          });
                        }),

                    const SizedBox(height: 16),
                    // Выбор дат (просто кнопка)
                    _buildDropdown(
                        label: 'periodicity Days',
                        options: weekDays,
                        initial: weekDays[0],
                        onChanged: (val) {
                          setState(() {
                            if (!selectedDates.contains(
                                selectedDates.indexOf(weekDays.indexOf(val!)) +
                                    1)) {
                              selectedDates.add(weekDays.indexOf(val!) + 1);
                            } else {
                              selectedDates.remove(weekDays.indexOf(val!) + 1);
                            }
                          });
                        }),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Gap(16),
                        AppButton(
                          color: ButtonColors.grey,
                          onPressed: () => _showDatePicker(context),
                          widget: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                            ),
                            child: SizedBox(
                              width: getWidth(0.372, context),
                              child: const Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    'periodicity\ndays',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF790AA3),
                                      fontSize: 16,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      height: 1.07,
                                    ),
                                  ),
                                  Spacer(),
                                  Icon(
                                    Icons.keyboard_arrow_down_outlined,
                                    color: Color(0x91790AA3),
                                  ),
                                  Gap(10)
                                ],
                              ),
                            ),
                          ),
                        ),
                        Gap(11),
                        AppTextField(
                          height: 52,
                          width: getWidth(1, context) -
                              getWidth(0.372, context) -
                              44,
                          controller: selectedPeriodicityCount,
                          textInputType: TextInputType.number,
                          placeholder: 'candy count',
                          hints: candiesHint.toList(),
                        ),
                        Gap(17)
                      ],
                    ),
                    _buildTextField(
                        label: 'periodicity count',
                        controller: selectedPeriodicityCount,
                        hints: []),

                    const SizedBox(height: 16),
                    AppButton(
                      radius: 11,
                      color: ButtonColors.pink,
                      onPressed: () {
                        final candy = Candy(
                          id: const Uuid().v4(),
                          name: _nameController.text,
                          category: categoriesHint.firstWhere(
                            (e) => e.name == _usageCategoryController.text,
                            orElse: () => SweetCategory(
                                id: const Uuid().v4(),
                                name: _usageCategoryController.text),
                          ),
                          location: StorageLocation.values.firstWhere(
                              (e) => e.name == selectedLocation,
                              orElse: () => StorageLocation.values.first),
                          quantity: quantityController.text.isNotEmpty
                              ? int.parse(quantityController.text)
                              : 0,
                          expirationDate: selectedExpirationDate,
                          isPermanent: recurringCandy,
                          isPeriodic: recurringCandy,
                          currentPeriodicIndex: 0,
                          periodicityDays: selectedDates.isEmpty
                              ? null
                              : selectedDates.map((e) => e).toList(),
                          periodicityCount:
                              int.tryParse(selectedPeriodicityCount.text) ?? 0,
                          type: SweetType.values.firstWhere(
                              (e) => e.name == selectedCategory,
                              orElse: () => SweetType.values.first),
                          imageUrl: selectedImage,
                          isTemplate: saveTemplate,
                        );
                        if (widget.candy != null) {
                          candy.copyWith(id: widget.candy!.id);
                        }
                        if (addToCart) {
                          context.read<CandyBloc>().add(AddToShoppingList(
                              id: const Uuid().v4(), candy: candy));
                        } else if (widget.candy != null) {
                          context.read<CandyBloc>().add(UpdateCandy(candy));
                        } else {
                          context.read<CandyBloc>().add(SaveCandy(candy));
                        }

                        context.pop();
                      },
                      widget: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 110, vertical: 14),
                        child: Text(
                          'save',
                          style: TextStyle(
                            color: Colors.white,
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
                    )
                  ],
                ),
              ),
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
