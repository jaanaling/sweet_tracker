import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sweet_planner/src/feature/candy/bloc/candy_bloc.dart';

class AddSweetScreen extends StatelessWidget {
  const AddSweetScreen({Key? key}) : super(key: key);

  // Поле для ввода текста
  Widget _buildTextField({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextField(
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: label,
          ),
        ),
      ],
    );
  }

  // Выпадающий список (категория, место хранения)
  Widget _buildDropdown({required String label}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          isExpanded: true,
          value: null,
          items: const [
            DropdownMenuItem(value: 'Option 1', child: Text('Option 1')),
            DropdownMenuItem(value: 'Option 2', child: Text('Option 2')),
          ],
          onChanged: (val) {},
        ),
      ],
    );
  }

  // Переключатели (свитчи)
  Widget _buildSwitch({required String label, bool initial = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Switch(value: initial, onChanged: (val) {}),
      ],
    );
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
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.camera_alt),
                  ),
                  const SizedBox(height: 16),

                  _buildTextField(label: 'Name'),
                  const SizedBox(height: 16),

                  _buildDropdown(label: 'Category'),
                  const SizedBox(height: 16),

                  _buildDropdown(label: 'Storage location'),
                  const SizedBox(height: 16),

                  _buildTextField(label: 'Expiration Date'),
                  const SizedBox(height: 16),

                  _buildDropdown(label: 'Usage category'),
                  const SizedBox(height: 16),

                  _buildSwitch(label: 'Recurring candy'),
                  _buildSwitch(label: 'Save template'),
                  _buildSwitch(label: 'Auto-add to cart'),

                  const SizedBox(height: 16),
                  // Выбор дат (просто кнопка)
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Choose dates'),
                  ),
                  const SizedBox(height: 16),

                  // Примерное текстовое поле для заметок
                  _buildTextField(label: 'Notes'),

                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
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
