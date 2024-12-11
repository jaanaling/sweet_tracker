import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:inner_glow/inner_glow.dart';
import 'package:sweet_planner/src/core/utils/app_icon.dart';
import 'package:sweet_planner/src/core/utils/icon_provider.dart';
import 'package:sweet_planner/src/core/utils/size_utils.dart';

class AppTextField extends StatelessWidget {
  final double width;

  final TextInputType textInputType;
  final TextEditingController controller;
  final Function(String)? onChanged;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final Widget? suffix;
  final String? placeholder;
  final double textSize;
  final double height;
  final String? topText;
  final List<TextInputFormatter>? inputFormatters;
  final int maxLine;

  const AppTextField({
    super.key,
    required this.controller,
    this.onSaved,
    this.textSize = 35,
    this.maxLine = 1,
    this.validator,
    this.placeholder,
    this.textInputType = TextInputType.text,
    this.width = 0.888,
    this.onChanged,
    this.suffix,
    required this.height,
    this.inputFormatters,
    this.topText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (topText != null)
          Text(
            topText ?? '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontFamily: 'Jellee',
              shadows: <Shadow>[
                Shadow(
                  offset: Offset(2.0, 2.0),
                  blurRadius: 4.0,
                  color: Colors.black.withOpacity(0.5),
                ),
              ],
              fontWeight: FontWeight.w700,
              height: 0,
            ),
          ),
        Gap(8),
        InnerGlow(
            width: width * MediaQuery.of(context).size.width,
            height: height + 10,
            glowRadius: 20,
            strokeLinearGradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Colors.black.withOpacity(0.15)],
            ),
            baseDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.grey,
              border: Border.all(width: 1, color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Color(0x63220052),
                  blurRadius: 6.40,
                  offset: Offset(0, 4),
                  spreadRadius: 0,
                )
              ],
            ),
            child: Center(
                child: InnerGlow(
              width: width * MediaQuery.of(context).size.width - 10,
              height: height,
              glowRadius: 15,
              strokeLinearGradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.15)
                ],
              ),
              baseDecoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                border: Border.all(width: 1, color: Colors.white),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 19, right: 14),
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      errorStyle: TextStyle(
                        fontSize: 12,
                        color: Colors.red,
                        // Настройка выравнивания
                      ),
                      suffix: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: suffix == null ? 0 : 12,
                            vertical: suffix == null ? 0 : 13),
                        child: suffix,
                      ),
                      hintText: placeholder,

                      hintStyle: TextStyle(
                        color: Color(0x35561A9E),
                        fontSize: textSize,
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
                    maxLines: maxLine,
                    keyboardType: textInputType,
                    style: TextStyle(
                      fontSize: textSize,
                      color: Color(0xFF1E0042),
                      shadows: <Shadow>[
                        Shadow(
                          offset: Offset(2.0, 2.0),
                          blurRadius: 4.0,
                          color: Colors.grey.withOpacity(0.5),
                        ),
                      ],
                    ),
                    inputFormatters: inputFormatters,
                  ),
                ),
              ),
            )))
      ],
    );
  }
}

class SearchTextField extends StatelessWidget {
  final TextEditingController controller;
 final VoidCallback onChanged;
  const SearchTextField({super.key, required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(1, context) - 132,
      height: 48,
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment(0.00, -1.00),
          end: Alignment(0, 1),
          colors: [Color(0xFFEEEEEE), Color(0xFFD5B3E1)],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 0.50, color: Colors.white),
          borderRadius: BorderRadius.circular(9),
        ),
      ),
      child: CupertinoTextField(
        prefix: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Icon(
            CupertinoIcons.search,
            color: Color(0x8E350047),
          ),
        ),
        onChanged: (value){
          onChanged();
        },
        decoration: BoxDecoration(
          gradient: LinearGradient(
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
