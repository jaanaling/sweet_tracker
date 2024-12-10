import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_button/app_button.dart';

class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String)? onChanged;
  final Function()? onAdd;
  final Function()? onRemove;
  final String? placeholder;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;

  const NumberField(
      {super.key,
      required this.controller,
      this.onAdd,
      this.onRemove,
      this.onChanged,
      this.placeholder,
      this.onSaved,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          border: Border.all(color: Color(0xFFE2389E), width: 6),
          borderRadius: BorderRadius.circular(14),
          gradient: RadialGradient(colors: [
            Colors.white,
            Color(0xFFFBCEEE),
          ], radius: 1)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppButton(
              color: ButtonColors.red,
              radius: 8,
              onPressed: onRemove,
              widget: SizedBox(
                width: 49,
                height: 28,
                child: Center(
                  child: Container(
                    width: 26,
                    height: 5,
                    decoration: ShapeDecoration(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.569 - 20,
              child: TextFormField(
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  errorStyle: TextStyle(
                    fontSize: 12,
                    color: Colors.red,
                    // Настройка выравнивания
                  ),

                  hintText: placeholder,

                  hintStyle: const TextStyle(
                    color: Color(0x35561A9E),
                    fontSize: 56,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.05,
                    shadows: [],
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 13), // Уточнение стиля
                  filled: true,
                  fillColor: Colors.transparent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(26),
                    borderSide: BorderSide.none,
                  ),
                ),
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                controller: controller,
                onChanged: onChanged,
                onSaved: onSaved,
                validator: validator,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  
                  color: Color(0xFF220028),
                  fontSize: 56,
                  fontFamily: 'Jellee',
                  fontWeight: FontWeight.w700,
                  height: 0,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  FilteringTextInputFormatter.allow(RegExp(r'^[0-9]*$')),
                ],
              ),
            ),
            AppButton(
              color: ButtonColors.green,
              onPressed: onAdd,
              radius: 8,
              widget: SizedBox(
                width: 49,
                height: 28,
                child: Center(
                    child: Icon(
                  CupertinoIcons.plus,
                  color: Colors.white,
                )),
              ),
            )
          ],
        ),
      ),
    );
  }
}
