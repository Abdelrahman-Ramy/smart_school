import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:smart_school/core/theming/app_colors.dart';

class AppTextFormField extends StatefulWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final String hintText;
  final TextEditingController controller;
  final TextStyle? hintStyle;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final bool? isPhone;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    required this.hintText,
    required this.controller,
    this.isObscureText,
    this.suffixIcon,
    this.hintStyle,
    this.backgroundColor,
    this.textInputAction,
    this.keyboardType,
    this.isPhone,
  });

  @override
  State<AppTextFormField> createState() => _AppTextFormFieldState();
}

class _AppTextFormFieldState extends State<AppTextFormField> {
  Country? selectedCountry;
  late MaskTextInputFormatter maskFormatter;
  @override
  void initState() {
    super.initState();
    maskFormatter = MaskTextInputFormatter(
      mask: '### ### ####',
      filter: {"#": RegExp(r'[0-9]')},
    );
  }

  void updateMask(Country country) {
    String newMask;

    if (country.phoneCode == '20') {
      newMask = '### ### ####';
    } else if (country.phoneCode == '966' ||
        country.phoneCode == '212' ||
        country.phoneCode == '216' ||
        country.phoneCode == '213') {
      newMask = '### ### ###';
    } else if (country.phoneCode == '971' || country.phoneCode == '249') {
      newMask = '## ### ####';
    } else if (country.phoneCode == '965' ||
        country.phoneCode == '974' ||
        country.phoneCode == '973' ||
        country.phoneCode == '968') {
      newMask = '#### ####';
    } else if (country.phoneCode == '962' || country.phoneCode == '961') {
      newMask = '## ### ###';
    } else {
      newMask = '###############';
    }

    setState(() {
      selectedCountry = country;
      widget.controller.clear();
      maskFormatter.updateMask(mask: newMask);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.isPhone ?? false ? [maskFormatter] : [],
      style: const TextStyle(fontSize: 20, color: AppColors.primaryColor),
      controller: widget.controller,
      cursorColor: AppColors.primaryColor,
      cursorWidth: 1.5,
      cursorHeight: 25,
      cursorRadius: Radius.circular(8.r),
      obscureText: widget.isObscureText ?? false,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'please fill ${widget.hintText}';
        }
        null;
      },
      decoration: InputDecoration(
        hintStyle:
            widget.hintStyle ??
            TextStyle(fontSize: 16.sp, color: AppColors.primaryColor),
        hintText: widget.hintText,
        suffixIcon: widget.suffixIcon,
        prefixIcon: widget.isPhone ?? false
            ? GestureDetector(
                onTap: () {
                  showCountryPicker(
                    context: context,
                    onSelect: (Country country) => updateMask(country),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "${selectedCountry?.flagEmoji ?? '🇪🇬'} +${selectedCountry?.phoneCode ?? '20'}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_drop_down,
                        color: AppColors.primaryColor,
                      ),
                      Container(
                        height: 20.h,
                        width: 1,
                        color: AppColors.primaryColor.withOpacity(0.3),
                      ),
                      SizedBox(width: 8.w),
                    ],
                  ),
                ),
              )
            : null,
        isDense: true,
        fillColor: widget.backgroundColor ?? AppColors.whiteColor,
        filled: true,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(vertical: 13.h, horizontal: 20.w),
        focusedBorder:
            widget.focusedBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0.r),
              borderSide: const BorderSide(
                color: AppColors.primaryColor,
                width: 1.3,
              ),
            ),
        enabledBorder:
            widget.enabledBorder ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.0.r),
              borderSide: const BorderSide(
                color: AppColors.whiteColor,
                width: 1.3,
              ),
            ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(color: AppColors.whiteColor, width: 1.3),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(color: AppColors.whiteColor, width: 1.3),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0.r),
          borderSide: const BorderSide(color: AppColors.redColor, width: 1.3),
        ),
      ),
    );
  }
}
