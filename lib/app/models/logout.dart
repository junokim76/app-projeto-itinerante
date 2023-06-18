import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../views/login.dart';

class AuthService {
  static void logout(BuildContext context) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
    print('Usuário deslogado');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
