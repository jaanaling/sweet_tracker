import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:sweet_planner/src/core/utils/size_utils.dart';
import 'package:sweet_planner/ui_kit/app_button/app_button.dart';

class AppTextField extends StatelessWidget {
  final double height;
  final double width;
  final double borderRadius;
  final TextEditingController controller;
  final TextInputType textInputType;
  final Function(String)? onChanged;
  final Function(String)? onSave;
  final String? placeholder;
  final double textSize;
  final List<String>? hints;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLine;
  const AppTextField({
    super.key,
    required this.height,
    required this.width,
    required this.controller,
    this.onChanged,
    this.placeholder,
    this.inputFormatters,
    this.textSize = 19,
    this.maxLine = 1,
    this.textInputType = TextInputType.text,
    this.onSave,
    this.borderRadius = 7,
    this.hints,
  });

  @override
  Widget build(BuildContext context) {
    return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
      return hints!.where((suggestion) {
        return suggestion
            .toLowerCase()
            .contains(textEditingValue.text.toLowerCase());
      }).toList();
    }, onSelected: (String selection) {
      controller.text = selection;
    }, optionsViewBuilder: (context, onSelected, options) {
      return Align(
        alignment: Alignment.topLeft,
        child: Material(
          child: SizedBox(
            width: getWidth(1, context) - 32,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  title: Text(
                    option,
                    style: TextStyle(
                      color: Color.fromARGB(255, 102, 8, 136),
                      fontSize: 14,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  onTap: () {
                    onSelected(option);
                  },
                );
              },
            ),
          ),
        ),
      );
    }, fieldViewBuilder: (context, controlller, focusNode, onEditingComplete) {
      if (controller.text.isNotEmpty && controlller.text.isEmpty) {
        controlller.text = controller.text;
      }

      return AppButton(
        color: ButtonColors.white,
        radius: borderRadius,
        widget: SizedBox(
          width: width,
          height: height - 12,
          child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: TextField(
                controller: controlller,
                focusNode: focusNode,
                onTapOutside: (event) {
                  onSave?.call(controller.text);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Color(0x82790AA3),
                    fontSize: textSize,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w400,
                  ),
                  hintText: placeholder,
                  contentPadding: const EdgeInsets.only(left: 18, bottom: 8),
                ),
                onChanged: onChanged,
                onSubmitted: onSave,
                inputFormatters: inputFormatters,
                maxLines: maxLine,
                keyboardType: textInputType,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  color: Color(0xFF790AA3),
                  fontSize: textSize,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
              )),
        ),
      );
    });
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;
  const SearchTextField({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(1, context) - 132,
      height: 48,
      decoration: ShapeDecoration(
        gradient: const LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFEEEEEE), Color(0xFFD5B3E1)],
        ),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 0.50, color: Colors.white),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: CupertinoTextField(
        prefix: const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(
            CupertinoIcons.search,
            color: Color(0x8E350047),
          ),
        ),
        onChanged: (value) {
          onChanged();
        },
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(0.00, -1.00),
            end: Alignment(0, 1),
            colors: [Color(0xFFEEEEEE), Color(0xFFD5B3E1)],
          ),
          border: Border.all(width: 0.50, color: Colors.white),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
    );
  }
}
