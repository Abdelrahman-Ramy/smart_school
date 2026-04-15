import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/routing/app_router.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/parent/views/parent_root.dart';
import 'package:smart_school/features/teacher/views/teacher_home_view.dart';
import 'package:smart_school/features/teacher/views/teacher_root.dart';
import 'package:smart_school/shared/splash_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: AppColors.whiteColor,
          ),
          splashColor: Colors.transparent,
          scaffoldBackgroundColor: AppColors.whiteColor,
        ),
        home: const ParentRoot(),
        onGenerateRoute: AppRouter().generateRoute,
      ),
    );
  }
}
