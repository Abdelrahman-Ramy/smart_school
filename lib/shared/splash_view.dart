import 'package:flutter/material.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/features/student/views/student_root.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  double slide = 0;

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(milliseconds: 400), () {
      setState(() {
        slide = 300;
      });
    });

    Future.delayed(
      const Duration(seconds: 3),
      () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => StudentRoot()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(
              'assets/images/logo_splash.png',
            ),

            AnimatedPositioned(
              duration: const Duration(milliseconds: 2500),
              curve: Curves.easeOutCubic,
              left: slide,
              child: Container(
                width: 200,
                height: 200,
                color: AppColors.whiteColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}