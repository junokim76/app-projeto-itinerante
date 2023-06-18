import 'package:firebase_auth/firebase_auth.dart';

Future<bool> checkUserLoggedIn() async {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}
