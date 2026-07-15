import 'package:flutter/material.dart';
import 'package:smart_school/core/routing/routes.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/onboarding/widgets/custom_continer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<Widget> _pages = [
    const CustomContainer(
      image: "assets/images/onboarding2.jpeg",
      title: "Welcome to Smart School",
      description:
          "Connect teachers, students, and parents in one smart platform designed to simplify learning, communication, and school management.",
    ),
    const CustomContainer(
      image: "assets/images/onboarding3.jpeg",
      title: "Everything in One Place",
      description:
          "Manage assignments, educational materials, grades, attendance, and notifications through a single, organized system.",
    ),
    const CustomContainer(
      image: "assets/images/onboarding1.jpeg",
      title: "Learn Smarter with AI",
      description:
          "Get instant assistance through our AI chatbot, communicate easily, and stay connected with everything that matters in your educational journey.",
    ),
  ];
  void _skip() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _onFinish();
    }
  }

  void _onFinish() {
    Navigator.pushReplacementNamed(context, Routes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) => _pages[index],
          ),
          _currentPage == _pages.length - 1
              ? SizedBox.shrink()
              : Positioned(
                  bottom: 70,
                  left: 30,
                  child: TextButton(
                    onPressed: _skip,
                    child: Text('Skip', style: AppStyle.font15BlackBold),
                  ),
                ),
          Positioned(
            bottom: 70,
            right: 30,
            child: TextButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                style: AppStyle.font15BlackBold,
              ),
            ),
          ),
          Positioned(
            bottom: 90,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _pageController,
                count: _pages.length,
                effect: const WormEffect(
                  dotHeight: 12,
                  dotWidth: 12,
                  activeDotColor: AppColors.primaryColor,
                  dotColor: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
