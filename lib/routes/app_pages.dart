// lib/app/routes/app_pages.dart
import 'package:blf/app/modules/Splashscreen/splash_screen.dart';
import 'package:blf/app/modules/auth/controller/login_controller.dart';
import 'package:blf/app/modules/auth/views/loginpage.dart';
import 'package:blf/app/modules/bottombar/bottom_nav_page.dart';
import 'package:blf/app/modules/home/home_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app_routes.dart'; // 👈 Import Routes here

class AppPages {
  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(name: Routes.SPLASH, page: () => const SplashScreen()),

    GetPage(
      name: Routes.HOME,
      page: () => HomeScreen(scaffoldKey: GlobalKey<ScaffoldState>()),
    ),
    GetPage(name: Routes.BOTTOM_NAV, page: () => BottomNavPage()),

    GetPage(
      name: Routes.LOGIN,
      page: () => LoginView(),
      binding: BindingsBuilder(() {
        Get.lazyPut<LoginController>(() => LoginController());
      }),
    ),
  ];
}
