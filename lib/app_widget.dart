import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ponto_prevent/views/pages/home/http/repository/http_bindings.dart';
import 'models/user_model.dart';
import 'themes/app_colors.dart';
import 'views/pages/home/home_page.dart';
import 'views/pages/login/login_page.dart';
import 'views/pages/splash/splash_page.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ponto Prevent',
      theme: ThemeData(primaryColor: AppColors.primary),
      initialRoute: "/splash",
      // getPages: [
      //   GetPage(
      //     name: '/',
      //     page: () => HomePage(
      //         user: ModalRoute.of(context)!.settings.arguments as UserModel),
      //     binding: HttpBindings(),
      //   ),
      //   GetPage(name: '/splash', page: () => SplashPage()),
      //   GetPage(name: '/login', page: () => LoginPage()),
      // ],
      routes: {
        "/home": (context) => HomePage(
            user: ModalRoute.of(context)!.settings.arguments as UserModel),
        "/splash": (context) => SplashPage(),
        "/login": (context) => LoginPage(),
      },
    );
  }
}
