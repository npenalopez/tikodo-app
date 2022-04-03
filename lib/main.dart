import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tikodo_app/pages/login_page.dart';
import 'package:tikodo_app/pages/register_page.dart';
import 'package:tikodo_app/pages/tikodo_page.dart';
import 'package:tikodo_app/services/shared_service.dart';

Widget defaultRoute = const LoginPage();

void main() async {
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
        primaryColor: HexColor("#B5140E"),
        colorScheme: ColorScheme(
          primary: HexColor("#B5140E"),
          secondary: HexColor("#B5140E"),
          surface: HexColor("#B5140E"),
          background: HexColor("#B5140E"),
          error: HexColor("#B5140E"),
          onPrimary: HexColor("#B5140E"),
          onSecondary: HexColor("#B5140E"),
          onSurface: HexColor("#B5140E"),
          onBackground: HexColor("#B5140E"),
          onError: HexColor("#B5140E"),
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
