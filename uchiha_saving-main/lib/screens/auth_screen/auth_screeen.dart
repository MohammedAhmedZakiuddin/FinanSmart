import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttericon/font_awesome5_icons.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:uchiha_saving/api/auth.dart';
import 'package:uchiha_saving/api/auth_base.dart';
import 'package:uchiha_saving/screens/auth_screen/components/login_header.dart';
import 'package:uchiha_saving/screens/auth_screen/components/teddy_controller.dart';
import 'package:uchiha_saving/screens/auth_screen/components/tracking_text_input.dart';
import 'package:uchiha_saving/tools/error_dialog.dart';
import 'package:flare_flutter/flare_actor.dart';

enum LoginFormType { login, register }

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  AuthBase _auth = Auth();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> _resetKey = GlobalKey<FormState>();
  LoginFormType _loginForm = LoginFormType.login;
  TextEditingController _resetEmailController = TextEditingController();

  toggleForm() {
    bool _loginFormType = _loginForm == LoginFormType.login;

    setState(() {
      _loginFormType
          ? _loginForm = LoginFormType.register
          : _loginForm = LoginFormType.login;
      _formKey.currentState!.reset();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _resetEmailController.dispose();
    super.dispose();
  }

  TeddyController _teddyController = TeddyController();

  String? _email, _password, _confirmPassword;

  @override
  Widget build(BuildContext context) {
    bool _loginFormType = _loginForm == LoginFormType.login;
    final _size = MediaQuery.of(context).size;
    return ThemeConsumer(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: Scaffold(
          body: Center(
            child: ListView(
              children: [
                Container(
                  height: _size.height * 0.27,
                  width: _size.width,
                  margin: EdgeInsets.only(bottom: 10),
                  child: FlareActor(
                    "assets/animations/Teddy.flr",
                    shouldClip: false,
                    alignment: Alignment.bottomCenter,
                    fit: BoxFit.cover,
                    controller: _teddyController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    elevation: 20,
                    child: Form(
                      key: _formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LoginHeader(
                                key: widget.key,
                                title: _loginFormType ? "Sign In" : "Register"),
                            SizedBox(height: 15),

                            TrackingTextInput(
                              hint: "Email Address",
                              isObscured: false,
                              icon: Icons.email,
                              onCaretMoved: (Offset caret) {
                                _teddyController.coverEyes(false);
                                _teddyController.lookAt(caret);
                              },
                              onTextChanged: (val) {
                                setState(() {
                                  _email = val;
                                });
                              },
                              validator: EmailValidator(
                                  errorText: 'Enter a valid email address'),
                            ),
                            SizedBox(height: 10),
                            TrackingTextInput(
                              hint: "Password",
                              isObscured: true,
                              icon: Icons.password,
                              onCaretMoved: (Offset caret) {
                                _teddyController.coverEyes(true);
                                _teddyController.lookAt(Offset(0, 0));
                              },
                              onTextChanged: (String value) {
                                setState(() {
                                  _teddyController.setPassword(value);
                                  _password = value;
                                });
                              },
                              validator: (val) {
                                if (val.isEmpty || val.length < 6) {
                                  return "Please enter 6 characters password";
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            _loginFormType
                                ? Center()
                                : TrackingTextInput(
                                    hint: "Confirm Password",
                                    isObscured: true,
                                    icon: Icons.security,
                                    onCaretMoved: (Offset caret) {
                                      _teddyController.coverEyes(true);
                                      _teddyController.lookAt(Offset(0, 0));
                                    },
                                    onTextChanged: (String value) {
                                      setState(() {
                                        _confirmPassword = value;
                                      });
                                    },
                                    validator: (val) {
                                      if (val != _password) {
                                        return "Password does not match";
                                      }
                                    },
                                  ),
                            SizedBox(height: _loginFormType ? 0 : 10),
                            // ignore: deprecated_member_use
                            if (_loginFormType)
                              // ignore: deprecated_member_use
                              FlatButton(
                                onPressed: () => _forgetPassword(_size),
                                child: Text(
                                  "Forget Password?",
                                  style: GoogleFonts.lato(
                                    fontSize: _size.height * 0.020,
                                  ),
                                ),
                              ),

                            MaterialButton(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () => _submit(_loginFormType),
                              color: Colors.red,
                              child: Text(
                                _loginFormType ? "Login" : "Register",
                                style: GoogleFonts.lato(
                                  fontSize: _size.height * 0.023,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            // ignore: deprecated_member_use
                            FlatButton(
                              onPressed: toggleForm,
                              child: Text(
                                _loginFormType
                                    ? "Don't have an account? Register"
                                    : "Already have an account? Login",
                                style: GoogleFonts.lato(
                                  fontSize: _size.height * 0.020,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                _auth.signinWithGoogle();
                              },
                              color: Colors.black,
                              icon: Icon(
                                FontAwesome5.google,
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _forgetPassword(Size size) {
    showDialog(
        context: context,
        builder: (ctx) {
          return SimpleDialog(
            title: Text("Reset Password"),
            insetPadding: const EdgeInsets.all(8.0),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _resetKey,
                  child: TextFormField(
                    controller: _resetEmailController,
                    decoration: InputDecoration(
                      hintText: "Email",
                      icon: Icon(Icons.email),
                    ),
                    validator: EmailValidator(errorText: "Enter Valid Email"),
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  _resetKey.currentState!.save();
                  if (_resetKey.currentState!.validate())
                    _auth
                        .resetPassword(
                            _resetEmailController.text.toLowerCase().trim())
                        .catchError((error) {
                          errorDialog(
                              title: "Error",
                              content: error.message,
                              context: context);
                        })
                        .then((value) => Navigator.pop(context))
                        .whenComplete(() {
                          showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                    content: Text(
                                        "Reset link sent to ${_resetEmailController.text.trim()}"));
                              });
                        });
                },
                child: Text(
                  "Submit",
                  style: GoogleFonts.lato(
                    fontSize: size.height * 0.023,
                  ),
                ),
              ),
            ],
          );
        });
  }

  _submit(bool loginFormType) {
    _formKey.currentState!.save();
    if (_formKey.currentState!.validate()) {
      loginFormType
          ? _auth
              .signInWithEmailAndPassword(
              _email!.toLowerCase().trim(),
              _password!.trim(),
            )
              .catchError((error) {
              errorDialog(
                  title: "Login failed",
                  content: error.message.toString(),
                  context: context);
            }).whenComplete(() {})
          : _auth
              .registerWithEmailAndPassword(
              _email!.toLowerCase().trim(),
              _password!.trim(),
            )
              .catchError((error) {
              errorDialog(
                  title: "Register failed",
                  content: error.message.toString(),
                  context: context);
            });
    }
  }
}
