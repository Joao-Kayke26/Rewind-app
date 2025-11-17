import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = AuthService();
  final logged = await auth.isLogged();

  runApp(MyApp(initialRouteIsHome: logged));
}

class MyApp extends StatelessWidget {
  final bool initialRouteIsHome;
  const MyApp({required this.initialRouteIsHome, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Netflix Clone',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(bodyMedium: TextStyle(color: Colors.white)),
      ),
      home: const LoginPage(),
    );
  }
}
