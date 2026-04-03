import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/teacher/widgets/custom_file_card.dart';
import 'package:smart_school/features/teacher/widgets/custom_upload_area.dart';

class CustomAttachmentSection extends StatefulWidget {
  final Function(PlatformFile?) onFileChanged;

  const CustomAttachmentSection({
    super.key,
    required this.onFileChanged,
  });

  @override
  State<CustomAttachmentSection> createState() => _CustomAttachmentSectionState();
}

class _CustomAttachmentSectionState extends State<CustomAttachmentSection> {
  PlatformFile? pickedFile;
  bool isUploading = false;

  @override
  Widget build(BuildContext context) {
    if (isUploading) {
      return Container(
        height: 100.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: const CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (pickedFile != null) {
      return CustomFileCard(
        fileName: pickedFile!.name,
        onDelete: () {
          setState(() {
            pickedFile = null;
          });
          widget.onFileChanged(null);
        },
      );
    }

    return CustomUploadArea(
      onTap: () async {
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.custom,
          allowedExtensions: ['pdf', 'doc', 'docx', 'png', 'jpg'],
        );

        if (result != null) {
          setState(() => isUploading = true);
          
          await Future.delayed(const Duration(seconds: 1));

          setState(() {
            isUploading = false;
            pickedFile = result.files.first;
          });
          widget.onFileChanged(pickedFile);
        }
      },
    );
  }
}