import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:user_app/auth/auth_service.dart';
import 'package:user_app/auth/ui/login_screen.dart';
import 'package:user_app/auth/ui/signup_screen.dart';
import 'package:user_app/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        "/" : (context) => const LoginScreen(),
        "/login" : (context) => const LoginScreen(),
        "/signup" : (context) => const SignUpScreen(),
        "/home" : (context) =>  const MyHomePage(),
      },
    );
  }
}
class CheckUser extends StatefulWidget {
  const CheckUser({super.key});

  @override
  State<CheckUser> createState() => _CheckUserState();
}

class _CheckUserState extends State<CheckUser> {
  @override
  void initState() {
   AuthService.isUserLoggedIn().then((value){
  if (value) {
  Navigator.pushReplacementNamed(context, "/home");
}
   else{
    Navigator.pushReplacementNamed(context, "/login");
  }
   });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator()
      ),
    );
  }
}

