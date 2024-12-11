import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';
import 'package:sweet_planner/src/feature/candy/model/candy.dart';
import 'package:sweet_planner/src/feature/candy/model/storage_location.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_category.dart';
import 'package:sweet_planner/src/feature/candy/model/sweet_type.dart';
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
    }
    if (widget.isShop != null) {
      addToCart = widget.isShop!;
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
                decoration: InputDecoration(
                  hintText: 'Введите название конфеты',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search),
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
      required Function(bool) onChanged}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: initial, onChanged: onChanged),
      ],
    );
  }

  void _showDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Выберите дату'),
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
            child: const Text('Отмена'),
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

          return Scaffold(
            appBar: AppBar(
              title: const Text('Add sweets'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigator.pop(context);
                },
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Кнопка загрузки изображения (плейсхолдер)
                  GestureDetector(
                    onTap:
                        _pickImage, // Open gallery when the container is tapped
                    child: Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey.shade300,
                      child: selectedImage == null
                          ? const Icon(Icons
                              .camera_alt) // Show icon if no image is selected
                          : Image.file(
                              File(selectedImage!), // Show the selected image
                              fit: BoxFit
                                  .cover, // Ensure the image fits well inside the container
                            ),
                    ),
                  ),
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
                      onChanged: (val) {
                        setState(() {
                          recurringCandy = val;
                        });
                      }),
                  _buildSwitch(
                      label: 'Save template',
                      initial: saveTemplate,
                      onChanged: (val) {
                        setState(() {
                          saveTemplate = val;
                        });
                      }),
                  _buildSwitch(
                      label: 'Auto-add to cart',
                      initial: addToCart,
                      onChanged: (val) {
                        setState(() {
                          addToCart = val;
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
                              selectedDates.indexOf(weekDays.indexOf(val!))+1)) {
                            selectedDates.add(weekDays.indexOf(val!)+1);
                          } else {
                            selectedDates.remove(weekDays.indexOf(val!)+1);
                          }
                        });
                      }),
                  const SizedBox(height: 16),

                  // Примерное текстовое поле для заметок
                  _buildTextField(
                      label: 'periodicity count',
                      controller: selectedPeriodicityCount,
                      hints: []),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final candy = Candy(
                        id: Uuid().v4(),
                        name: _nameController.text,
                        category: categoriesHint.firstWhere(
                          (e) => e.name == _usageCategoryController.text,
                          orElse: () => SweetCategory(
                              id: Uuid().v4(),
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
                        context.read<CandyBloc>().add(
                            AddToShoppingList(id: Uuid().v4(), candy: candy));
                      } else if (widget.candy != null) {
                        context.read<CandyBloc>().add(UpdateCandy(candy));
                      } else {
                        context.read<CandyBloc>().add(SaveCandy(candy));
                      }

                      context.pop();
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text('Success'));
      },
    );
  }
}
