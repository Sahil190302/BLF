import 'package:blf/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blf/routes/app_pages.dart';
import 'package:blf/utils/app_colors.dart';
import 'app/services/api_client.dart';
import 'app/services/app_session.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppSession.init();
  runApp(const MyApp());
  ApiClient.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BLF',
      initialRoute: Routes.SPLASH,
      getPages: AppPages.routes,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        primaryColor: AppColors.primaryColor,
        fontFamily: 'Montserrat', // ✅ Global font
      ),
    );
  }
}
