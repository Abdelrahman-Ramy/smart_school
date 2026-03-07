import 'package:flutter/material.dart';
import 'package:smart_school/core/theming/app_colors.dart';

class CustomSelectedType extends StatefulWidget {
  final String typeUser;
  final String selectedType;
  final ValueChanged<String> onChanged;
  const CustomSelectedType({
    required this.typeUser,
    required this.selectedType,
    required this.onChanged,
    super.key,
  }
  );

  @override
  State<CustomSelectedType> createState() => _CustomSelectedTypeState();
}

class _CustomSelectedTypeState extends State<CustomSelectedType> {

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.selectedType == widget.typeUser;
    return Row(
      children: [
        Radio<String>(
          fillColor: const WidgetStatePropertyAll(AppColors.primaryColor),
          value: widget.typeUser,
          activeColor: Colors.white,
          groupValue: widget.selectedType,
          onChanged: (value) {
            setState(() => widget.onChanged(widget.typeUser));
          },
        ),
        Text(
          widget.typeUser,
          style: TextStyle(
            color: isSelected ? AppColors.primaryColor : Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
