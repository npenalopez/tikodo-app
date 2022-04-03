import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tikodo_app/configuration.dart';
import 'package:tikodo_app/models/login_request_model.dart';
import 'package:tikodo_app/services/api_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool hidePassword = true;
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#FEFEFE"),
      body: ProgressHUD(
        indicatorColor: HexColor("#B5140E"),
        backgroundColor: HexColor("#FEFEFE"),
        child: Builder(
          builder: (context) => loginUI(context),
        ),
      ),
    );
  }

  Widget loginUI(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _loginImage(),
          _welcomeMessage(),
          Builder(
            builder: (context) => _loginForm(context),
          ),
          _registerLink(),
        ],
      ),
    );
  }

  Widget _loginImage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 10,
        top: 60,
      ),
      child: Align(
        alignment: Alignment.center,
        child: KeyboardVisibilityBuilder(
          builder: (context, isKeyboardVisible) {
            if (!isKeyboardVisible) {
              return Image.asset(
                "assets/images/LoginImage.png",
                width: 280,
                scale: 1,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Widget _welcomeMessage() {
    return Padding(
      padding: const EdgeInsets.only(
        left: 20,
        bottom: 30,
        top: 30,
      ),
      child: Text(
        "Sign in to tikoDo",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: HexColor("#3B3836"),
        ),
      ),
    );
  }

  Widget _loginForm(BuildContext context) {
    return Form(
      key: loginFormKey,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 10,
            ),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter email";
                }

                bool emailValid = RegExp(
                        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                    .hasMatch(value);

                if (!emailValid) {
                  return "Email is not valid.";
                }
                return null;
              },
              controller: emailLoginController,
              style: TextStyle(
                fontSize: 18,
                height: 1,
                color: HexColor("#3B3836"),
              ),
              decoration: InputDecoration(
                fillColor: HexColor("#f3f3f4"),
                filled: true,
                hintText: "Email Address",
                hintStyle: TextStyle(
                  color: HexColor("#3B3836"),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: HexColor("#B5140E"), width: 2.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: HexColor("#f3f3f4"), width: 2.0),
                ),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  }
                  return null;
                },
                controller: passwordLoginController,
                style: TextStyle(
                  fontSize: 18,
                  height: 1,
                  color: HexColor("#3B3836"),
                ),
                obscureText: hidePassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: HexColor("#B5140E").withOpacity(0.6),
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                  fillColor: HexColor("#f3f3f4"),
                  filled: true,
                  hintText: "Password",
                  hintStyle: TextStyle(
                    color: HexColor("#3B3836"),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: HexColor("#B5140E"),
                      width: 2.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    borderSide: BorderSide(
                      color: HexColor("#f3f3f4"),
                      width: 2.0,
                    ),
                  ),
                ),
              )),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: 20,
            ),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(HexColor("#B5140E")),
                ),
                onPressed: () {
                  if (loginFormKey.currentState!.validate()) {
                    /// shows the progress indicator
                    final progress = ProgressHUD.of(context);
                    progress?.show();

                    LoginRequestModel model = LoginRequestModel(
                      email: emailLoginController.text,
                      password: passwordLoginController.text,
                    );

                    APIService.login(model).then((response) {
                      /// hides the progress indicator
                      progress?.dismiss();

                      if (response == "") {
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          '/tikoDo',
                          (route) => false,
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(Config.appName),
                              content: Text(response),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      }
                    });
                  }
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(
                    color: HexColor("#FEFEFE"),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _registerLink() {
    return Text.rich(
      TextSpan(
          text: "Do not have an account yet? ",
          style: TextStyle(
            color: HexColor("#3B3836"),
          ),
          children: <InlineSpan>[
            TextSpan(
                text: 'Register now',
                style: TextStyle(
                    color: HexColor("#B5140E"), fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, "/register");
                  })
          ]),
    );
  }
}
