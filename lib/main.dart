import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tikodo_app/pages/login_page.dart';
import 'package:tikodo_app/pages/register_page.dart';
import 'package:tikodo_app/pages/tikodo_page.dart';
import 'package:tikodo_app/services/shared_service.dart';

Widget defaultRoute = const LoginPage();

void main() async {
  /// dynamically set the default route
  WidgetsFlutterBinding.ensureInitialized();
  bool result = await SharedService.isLoggedIn();
  if (result) {
    defaultRoute = const TikoDoPage();
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'tikoDo app',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: HexColor("#CB4E45"),
        colorScheme: ColorScheme(
          primary: HexColor("#CB4E45"),
          secondary: HexColor("#CB4E45"),
          surface: HexColor("#CB4E45"),
          background: HexColor("#CB4E45"),
          error: HexColor("#CB4E45"),
          onPrimary: HexColor("#CB4E45"),
          onSecondary: HexColor("#CB4E45"),
          onSurface: HexColor("#CB4E45"),
          onBackground: HexColor("#CB4E45"),
          onError: HexColor("#CB4E45"),
          brightness: Brightness.light,
        ),
      ),
      routes: {
        '/': (context) => defaultRoute,
        '/register': (context) => const RegisterPage(),
        '/login': (context) => const LoginPage(),
        '/tikoDo': (context) => const TikoDoPage(),
      },
    );
  }
}
