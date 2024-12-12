import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/core/utils/log.dart';
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

  DateTime? selectedExpirationDate;

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

  // Выбор даты
  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Choose expiration date'),
          message: SizedBox(
            height: 200,
            child: CupertinoDatePicker(
              initialDateTime: selectedExpirationDate,
              minimumDate: DateTime(2000),
              maximumDate: DateTime(2101),
              onDateTimeChanged: (DateTime newDate) {
                setState(() {
                  selectedExpirationDate = newDate;
                });
              },
              mode: CupertinoDatePickerMode.date,
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _showPicker(BuildContext context, String label, List<String> options,
      String initial, Function(String?) onChanged) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(label),
          message: SizedBox(
            height: 200,
            child: CupertinoPicker(
              itemExtent: 30,
              children: options.map((String value) {
                return Text(value);
              }).toList(),
              onSelectedItemChanged: (index) {
                onChanged(options[index]);
              },
            ),
          ),
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              context.pop();
            },
            child: const Text('Cancel'),
          ),
        );
      },
    );
  }

  void _showSelectDaysDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return CupertinoPopupSurface(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CupertinoColors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Select days',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: getHeight(0.5, context),
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: weekDays.length,
                          itemBuilder: (context, index) {
                            return CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              onPressed: () {
                                setState(() {
                                  _toggleDaySelection(index);
                                });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    weekDays[index],
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: selectedDates.contains(index + 1)
                                          ? Color.fromARGB(255, 175, 6, 147)
                                          : Colors.black,
                                    ),
                                  ),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor:
                                        Color.fromARGB(255, 175, 6, 147),
                                    value: selectedDates.contains(index + 1),
                                    onChanged: (value) {
                                      setState(() {
                                        _toggleDaySelection(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      CupertinoButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _toggleDaySelection(int index) {
    if (selectedDates.contains(index + 1)) {
      selectedDates.remove(index + 1);
    } else {
      selectedDates.add(index + 1);
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        selectedImage = pickedFile.path;
      });
    }
  }

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

  String formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  void _saveCandy(Set<SweetCategory> categoriesHint, BuildContext context) {
    // Валидация перед сохранением
    final name = _nameController.text.trim();
    final usageCategory = _usageCategoryController.text.trim();
    final location = selectedLocation?.trim();
    final category = selectedCategory?.trim();
    final quantityText = quantityController.text.trim();

    // Проверяем заполненность полей
    if (name.isEmpty) {
      _showError(context, 'Please enter a name.');
      return;
    }
    if (usageCategory.isEmpty) {
      _showError(context, 'Please enter a usage category.');
      return;
    }
    if (location == null || location.isEmpty) {
      _showError(context, 'Please select storage location.');
      return;
    }
    if (category == null || category.isEmpty) {
      _showError(context, 'Please select a category.');
      return;
    }
    if (quantityText.isEmpty || int.tryParse(quantityText) == null) {
      _showError(context, 'Please enter a valid quantity.');
      return;
    }

    final candy = Candy(
      id: widget.candy?.id ?? const Uuid().v4(),
      name: name,
      category: categoriesHint.firstWhere(
        (e) => e.name == usageCategory,
        orElse: () => SweetCategory(id: const Uuid().v4(), name: usageCategory),
      ),
      location: StorageLocation.values.firstWhere((e) => e.name == location,
          orElse: () => StorageLocation.values.first),
      quantity: int.parse(quantityText),
      expirationDate: selectedExpirationDate,
      isPermanent: recurringCandy,
      isPeriodic: recurringCandy,
      currentPeriodicIndex: selectedDates.isEmpty
          ? 0
          : selectedDates.indexOf(DateTime.now().weekday),
      periodicityDays:
          selectedDates.isEmpty ? null : selectedDates.map((e) => e).toList(),
      periodicityCount: int.tryParse(selectedPeriodicityCount.text) ?? 0,
      type: SweetType.values.firstWhere((e) => e.name == category,
          orElse: () => SweetType.values.first),
      imageUrl: selectedImage,
      isTemplate: saveTemplate,
    );

    if (addToCart) {
      context
          .read<CandyBloc>()
          .add(AddToShoppingList(id: const Uuid().v4(), candy: candy));
    } else if (widget.candy != null) {
      context.read<CandyBloc>().add(UpdateCandy(candy));
    } else {
      context.read<CandyBloc>().add(SaveCandy(candy));
    }

    context.pop();
  }

  void _showError(BuildContext context, String message) {
    showCupertinoDialog(
      context: context,
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                                              File(selectedImage!),
                                              fit: BoxFit.cover,
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
                              onChanged: (p0) => setState(() {
                                _nameController.text = p0;
                              }),
                              onSave: (p0) => setState(() {
                                _nameController.text = p0;
                              }),
                              height: 52,
                              width: getWidth(1, context) - 121.93 - 58,
                              controller: _nameController,
                              placeholder: 'Name',
                              hints: candiesHint.toList(),
                            ),
                            const Gap(14),
                            AppButton(
                              onPressed: () => _showPicker(
                                  context,
                                  'category',
                                  SweetType.values.map((e) => e.name).toList(),
                                  selectedCategory ?? '', (val) {
                                setState(() {
                                  selectedCategory = val;
                                });
                              }),
                              radius: 11,
                              color: ButtonColors.grey,
                              widget: Padding(
                                padding: const EdgeInsets.only(
                                  top: 4,
                                  bottom: 8,
                                ),
                                child: SizedBox(
                                  width: getWidth(1, context) - 121.93 - 58,
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Text(
                                        selectedCategory ?? 'category',
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
                          onPressed: () => _showPicker(
                              context,
                              'location',
                              StorageLocation.values
                                  .map((e) => e.name)
                                  .toList(),
                              selectedLocation ?? '', (val) {
                            setState(() {
                              selectedLocation = val;
                            });
                          }),
                          color: ButtonColors.grey,
                          widget: Padding(
                            padding: const EdgeInsets.only(
                              top: 4,
                              bottom: 8,
                            ),
                            child: SizedBox(
                              height: 35,
                              width: getWidth(1, context) / 2 - 20.5,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    selectedLocation ?? 'storage\nlocation',
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
                              height: 35,
                              child: Row(
                                children: [
                                  Spacer(),
                                  Text(
                                    selectedExpirationDate == null
                                        ? 'expiration\ndate'
                                        : "${formatDate(selectedExpirationDate!)}",
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
                      onChanged: (p0) => setState(() {
                        _usageCategoryController.text = p0;
                      }),
                      onSave: (p0) => setState(() {
                        _usageCategoryController.text = p0;
                      }),
                      height: 52,
                      borderRadius: 11,
                      width: getWidth(1, context) - 32,
                      controller: _usageCategoryController,
                      placeholder: 'Usage category',
                      hints: categoriesHint.map((e) => e.name).toList(),
                    ),
                    const Gap(13),
                    AppTextField(
                      onChanged: (p0) => setState(() {
                        quantityController.text = p0;
                      }),
                      onSave: (p0) => setState(() {
                        quantityController.text = p0;
                      }),
                      height: 52,
                      borderRadius: 11,
                      width: getWidth(1, context) - 32,
                      controller: quantityController,
                      placeholder: 'Quantity',
                      textInputType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
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
                        label: 'Add to cart',
                        initial: addToCart,
                        controller: _controller02,
                        onChanged: (val) {
                          setState(() {
                            addToCart = val as bool;
                          });
                        }),
                    const SizedBox(height: 16),
                    if (recurringCandy)
                      Row(
                        children: [
                          Gap(16),
                          AppButton(
                            color: ButtonColors.grey,
                            onPressed: () => _showSelectDaysDialog(context),
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
                            onChanged: (p0) => setState(() {
                              selectedPeriodicityCount.text = p0;
                            }),
                            onSave: (p0) => setState(() {
                              selectedPeriodicityCount.text = p0;
                            }),
                            height: 52,
                            width: getWidth(1, context) -
                                getWidth(0.372, context) -
                                44,
                            controller: selectedPeriodicityCount,
                            textInputType: TextInputType.number,
                            placeholder: 'candy count',
                          ),
                          Gap(17)
                        ],
                      ),
                    Gap(16),
                    AppButton(
                      radius: 11,
                      color: ButtonColors.pink,
                      onPressed: () {
                        _saveCandy(categoriesHint, context);
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
