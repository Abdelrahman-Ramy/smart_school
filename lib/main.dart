import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smart_school/core/helpers/hive_services.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/core/routing/app_navigator.dart';
import 'package:smart_school/core/routing/app_router.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/notifications/data/notification_push_service.dart';
import 'package:smart_school/features/teacher/cubit/attendance_cubit.dart';
import 'package:smart_school/features/teacher/data/teacher_repo.dart';
import 'package:smart_school/firebase_options.dart';
import 'package:smart_school/shared/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await HiveService.init();
  await PrefHelper.init();
  await NotificationPushService.instance.bootstrap();

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
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => AttendanceCubit(TeacherRepo())),
        ],
        child: MaterialApp(
          navigatorKey: AppNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            bottomSheetTheme: const BottomSheetThemeData(
              backgroundColor: AppColors.whiteColor,
            ),
            splashColor: Colors.transparent,
            scaffoldBackgroundColor: AppColors.whiteColor,
          ),
          home: const SplashView(),
          onGenerateRoute: AppRouter().generateRoute,
        ),
      ),
    );
  }
}
