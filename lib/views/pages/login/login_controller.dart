import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ponto_prevent/models/user_model.dart';
import 'package:ponto_prevent/shared/auth/auth_controller.dart';

class LoginController {
  final authController = AuthController();
  Future<void> googleSignIn(BuildContext context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: [
        'email',
      ],
    );
    try {
      final response = await _googleSignIn.signIn();
      final user = UserModel(
        name: response!.displayName!,
        id: response.id,
        photoURL: response.photoUrl,
      );
      authController.setUser(context, user);
      print("response: " + response.toString());
    } catch (error) {
      authController.setUser(context, null);
      print("erro: " + error.toString());
    }
  }
}
