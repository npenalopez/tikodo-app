import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:tikodo_app/configuration.dart';
import 'package:tikodo_app/models/register_request_model.dart';
import 'package:tikodo_app/services/api_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool hidePassword = true;
  bool hidePassword2 = true;
  GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();
  final TextEditingController firstNameRegisterController =
      TextEditingController();
  final TextEditingController lastNameRegisterController =
      TextEditingController();
  final TextEditingController emailRegisterController = TextEditingController();
  final TextEditingController passwordRegisterController =
      TextEditingController();
  final TextEditingController password2RegisterController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: HexColor("#FEFEFE"),
      body: ProgressHUD(
          child: Builder(
        builder: (context) => _registerUI(context),
      )),
    );
  }

  Widget _registerUI(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _registerTitle(),
        _loginLink(),
        const SizedBox(
          height: 30,
        ),
        _registerForm(),
      ],
    ));
  }

  Widget _registerTitle() {
    return const Padding(
        padding: EdgeInsets.only(
          left: 20,
          bottom: 20,
          top: 70,
        ),
        child: Text(
          "Register to tikoDo",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.black),
        ));
  }

  Widget _loginLink() {
    return Text.rich(
      TextSpan(
          text: "Already have an Account? ",
          style: TextStyle(
            color: HexColor("#3B3836"),
          ),
          children: <InlineSpan>[
            TextSpan(
                text: 'Sign in',
                style: TextStyle(
                    color: HexColor("#B5140E"), fontWeight: FontWeight.bold),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushNamed(context, "/");
                  })
          ]),
    );
  }

  Widget _registerForm() {
    return Form(
      key: registerFormKey,
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
                  return "Please enter firstname";
                }

                if (value.length >= 150) {
                  return "Must be less than 150 characters";
                }

                return null;
              },
              controller: firstNameRegisterController,
              style: TextStyle(
                fontSize: 18,
                height: 1,
                color: HexColor("#3B3836"),
              ),
              decoration: InputDecoration(
                fillColor: HexColor("#f3f3f4"),
                filled: true,
                hintText: "Firstname",
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
              bottom: 10,
            ),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Please enter lastname";
                }
                if (value.length >= 150) {
                  return "Must be less than 150 characters";
                }
                return null;
              },
              controller: lastNameRegisterController,
              style: TextStyle(
                fontSize: 18,
                height: 1,
                color: HexColor("#3B3836"),
              ),
              decoration: InputDecoration(
                fillColor: HexColor("#f3f3f4"),
                filled: true,
                hintText: "Lastname",
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
              controller: emailRegisterController,
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
                controller: passwordRegisterController,
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
              )),
          Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 20,
              ),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please confirm password";
                  }

                  if (value != passwordRegisterController.text) {
                    return "Password does not match";
                  }

                  return null;
                },
                controller: password2RegisterController,
                style: TextStyle(
                  fontSize: 18,
                  height: 1,
                  color: HexColor("#3B3836"),
                ),
                obscureText: hidePassword2,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword2 = !hidePassword2;
                      });
                    },
                    color: HexColor("#B5140E").withOpacity(0.6),
                    icon: Icon(hidePassword2
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                  fillColor: HexColor("#f3f3f4"),
                  filled: true,
                  hintText: "Confirm Password",
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
                        MaterialStateProperty.all<Color>(HexColor("#B5140E"))),
                onPressed: () {
                  if (registerFormKey.currentState!.validate()) {
                    final progress = ProgressHUD.of(context);
                    progress?.show();

                    RegisterRequestModel model = RegisterRequestModel(
                      firstName: firstNameRegisterController.text,
                      lastName: lastNameRegisterController.text,
                      email: emailRegisterController.text,
                      password2: password2RegisterController.text,
                      password: passwordRegisterController.text,
                    );
                    APIService.register(model).then((response) {
                      progress?.dismiss();

                      if (response.firstName.isNotEmpty) {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(Config.appName),
                              content: const Text(
                                  "Registration successful. Please login to the account."),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text("OK"),
                                  onPressed: () {
                                    Navigator.pushNamedAndRemoveUntil(
                                      context,
                                      '/login',
                                      (route) => false,
                                    );
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text(Config.appName),
                              content: Text(response.email),
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
                  "Create account",
                  style: TextStyle(color: HexColor("#FEFEFE")),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
