
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  Future<String> signUp(String email, String password) async {
    try {

      return "Sign Up Successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during sign-up";
    } catch (e) {
      return "An unexpected error occurred during sign-up: $e";
    }
  }

  Future<String> login(String email, String password) async {
    try {
      return "Login Successful";
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred during login";
    } catch (e) {
      return "An unexpected error occurred during login: $e";
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception("Sign Out Failed: $e");
    }
  }

  static Future <bool>isUserLoggedIn()  async {
    var currentUser = FirebaseAuth.instance.currentUser;
    return currentUser!=null ? true : false;
}

}
