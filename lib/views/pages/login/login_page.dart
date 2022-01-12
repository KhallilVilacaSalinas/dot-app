import 'package:flutter/material.dart';
import 'package:ponto_prevent/views/widgets/social_login_button.dart';

import 'login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final controller = LoginController();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double rigth = size.width * 0.11;
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: rigth, right: rigth, top: 60),
                  child: SocialLoginButton(
                    onTap: () => controller.googleSignIn(context),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
