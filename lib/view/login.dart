import 'package:expense/global/common/toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../provider/provider.dart';
import '../user_auth/firebase_auth_implementation/firebase_auth_services.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _isSignIn = false;

  bool _isPasswordHidden = false;

  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final RegExp emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegExp.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mqh = MediaQuery.of(context).size.height;
    var mqw = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: ListView(
            children: [
              SizedBox(
                height: mqh * .08,
              ),
              Container(
                height: mqh * .45,
                width: mqw * .9,
                child: SvgPicture.asset(
                  "assets/svg/login.svg",
                  fit: BoxFit.contain,
                ),
              ),
              // _isSignIn ? CircularProgressIndicator(color: CupertinoColors.activeBlue,):Text("Login"),
              TextFormField(
                focusNode: _emailFocusNode,
                validator: validateEmail,
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset("assets/svg/usernamme.svg"),
                  prefixIconConstraints:
                      const BoxConstraints(maxWidth: 50, minWidth: 50),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Email',
                  labelStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                controller: _emailController,
                // decoration: InputDecoration(labelText: 'Email'),
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                focusNode: _passwordFocusNode,
                validator: validatePassword,
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset("assets/svg/password.svg"),
                  prefixIconConstraints: const BoxConstraints(
                    maxWidth: 50,
                    minWidth: 50,
                  ),
                  suffixIcon:  IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordHidden = !_isPasswordHidden;
                            });
                          },
                          icon:_isPasswordHidden
                              ? const Icon(
                            CupertinoIcons.eye,
                            color: Colors.blue,
                          )
                      : const Icon(
                          CupertinoIcons.eye_slash,
                          color: Colors.blue,
                        ),),
                  suffixIconConstraints:
                      const BoxConstraints(maxWidth: 50, minWidth: 50),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Password',
                  labelStyle:
                      TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width: 1),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593)),
                  ),
                  errorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                  focusedErrorBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                  ),
                ),
                controller: _passwordController,
                obscureText: _isPasswordHidden?false:true,
              ),
              SizedBox(height: mqh * .09),
              Padding(
                padding: const EdgeInsets.only(left: 120.0,right: 120),
                child: GestureDetector(
                  onTap: (){signIn();
                    },
                  child: Container(
                      height: mqh * .05,
                      width: mqw * .3,
                      decoration: BoxDecoration(
                          color: Colors.blueAccent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isSignIn
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                          SizedBox(
                            width: mqw * .03,
                          ),
                          const Icon(
                            CupertinoIcons.arrow_right,
                            color: Colors.white,
                          )
                        ],
                      )
                      ),
                ),
              ),
              const SizedBox(height: 8.0),

              TextButton(
                onPressed: () {
                  resetPassword();
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),

              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/register');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account?',
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'Register',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void signIn() async {
    setState(() {
      _isSignIn = true;

    });
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signInWithEmailAndPassword(email, password);

    setState(() {
      _isSignIn = false;
    });
    if (user != null) {
      showToast(message: "User is successfully loggedIn");
      Provider.of<ExpenseProvider>(context, listen: false).setCurrentUser(user);


      Navigator.pushReplacementNamed(context, "/home");
    } else {
      showToast(message: "Some error happened");
    }
  }
  void resetPassword() async {
    String email = _emailController.text;

    // Check if email is provided
    if (email.isEmpty) {
      showToast(message: 'Please enter your email address');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showToast(message: 'Password reset email sent to $email');
    } catch (e) {
      print('Error sending password reset email: $e');
      showToast(message: 'An error occurred. Please try again later.');
    }
  }
}
