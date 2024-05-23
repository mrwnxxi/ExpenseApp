import 'package:expense/global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:expense/user_auth/firebase_auth_implementation/firebase_auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  bool _isSignUp = false;


  final FirebaseAuthService _auth = FirebaseAuthService();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _usernameFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  bool _isPasswordHidden = false;


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
  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameFocusNode.dispose();
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
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              SizedBox(height: mqh*.08,),
              Container(
                height: mqh * .45,
                width: mqw * .8,
                child: SvgPicture.asset(
                  "assets/svg/signup.svg",
                  fit: BoxFit.contain,
                ),
              ),
              TextFormField(
                focusNode: _usernameFocusNode,
                controller: _usernameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(CupertinoIcons.circle,color: Colors.blue,),
                  prefixIconConstraints: const BoxConstraints(maxWidth: 50,minWidth: 50,),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Username',
                  labelStyle:
                  TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width:1),
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
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_emailFocusNode);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                focusNode: _emailFocusNode,
                validator: validateEmail,
                controller: _emailController,
                decoration: InputDecoration(

                  prefixIcon: SvgPicture.asset("assets/svg/usernamme.svg"),
                  prefixIconConstraints: const BoxConstraints(maxWidth: 50,minWidth: 50,),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Email',
                  labelStyle:
                  TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width:1),
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
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_passwordFocusNode);
                },
              ),
              const SizedBox(height: 12.0),
              TextFormField(
                focusNode: _passwordFocusNode,
                validator: validatePassword,
                controller: _passwordController,
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset("assets/svg/password.svg"),
                  prefixIconConstraints: const BoxConstraints(maxWidth: 50,minWidth: 50,),
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
                  suffixIconConstraints: const BoxConstraints(maxWidth: 50,minWidth: 50),
                  contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
                  labelText: 'Password',
                  labelStyle:
                  TextStyle(color: Colors.grey.shade600, fontSize: 15),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF283593), width:1),
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
                obscureText: true,
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.only(left: 120.0,right: 120),
                child: GestureDetector(
                  onTap: signup,
                  child: Container(
                      height: mqh*.05,
                      width: mqw*.3,
                      decoration: BoxDecoration(color: Colors.blueAccent,borderRadius: BorderRadius.circular(10)),
                      child:Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _isSignUp ? const CircularProgressIndicator(color: CupertinoColors.white,):Text("Sign Up",style: TextStyle(color: Colors.white,fontSize: 20),),
                          SizedBox(width: mqw*.03,),
                          const Icon(CupertinoIcons.arrow_right,color: Colors.white,)
                        ],
                      )

                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);              },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account?',style: TextStyle(color: Colors.grey,fontSize: 15)),
                    Text('Sign In',style: TextStyle(color: Colors.blue,fontSize: 16),),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void signup() async {
    setState(() {
      _isSignUp = true;
    });
    String username = _usernameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    User? user = await _auth.signUpWithEmailAndPassword(email, password);

    setState(() {
      _isSignUp = false;
    });

    if (user != null){
      showToast(message: "User is successfully created");
      Navigator.pushNamed(context, "/");
    }else{
      showToast(message: "Some error happened");
    }
  }

}
