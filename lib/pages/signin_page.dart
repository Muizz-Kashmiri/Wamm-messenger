import 'package:wamm/pages/forgot_password.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wamm/helper/helper_functions.dart';
import 'package:wamm/pages/home_page.dart';
import 'package:wamm/services/auth_service.dart';
import 'package:wamm/services/database_service.dart';
import 'package:wamm/shared/constants.dart';
import 'package:wamm/shared/loading.dart';

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}




class SignInPage extends StatefulWidget {
  final Function toggleView;
  SignInPage({this.toggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // text field state
  String email = '';
  String password = '';
  String error = '';

  _onSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _isLoading = true;
      });

      await _auth
          .signInWithEmailAndPassword(email, password)
          .then((result) async {
        if (result != null) {
          QuerySnapshot userInfoSnapshot =
              await DatabaseService().getUserData(email);

          await HelperFunctions.saveUserLoggedInSharedPreference(true);
          await HelperFunctions.saveUserEmailSharedPreference(email);
          await HelperFunctions.saveUserNameSharedPreference(
              userInfoSnapshot.documents[0].data['fullName']);

          print("Signed In");
          await HelperFunctions.getUserLoggedInSharedPreference().then((value) {
            print("Logged in: $value");
          });
          await HelperFunctions.getUserEmailSharedPreference().then((value) {
            print("Email: $value");
          });
          await HelperFunctions.getUserNameSharedPreference().then((value) {
            print("Full Name: $value");
          });

          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage()));
        } else {
          setState(() {
            error = 'Error signing in!';
            _isLoading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            body: Form(
            key: _formKey,
            child: Container(
              color: Colors.black,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 80.0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text("Create or Join Groups & Chat with Friends",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold)),
                      SizedBox(height: 30.0),
                      Text("Sign In",
                          style:
                              TextStyle(color: Colors.white, fontSize: 25.0)),
                      SizedBox(height: 20.0),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Email'),
                        validator: (val) {
                          return RegExp(
                                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(val)
                              ? null
                              : "Please enter a valid email";
                        },
                        onChanged: (val) {
                          setState(() {
                            email = val;
                          });
                        },
                      ),
                      SizedBox(height: 15.0),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration:
                            textInputDecoration.copyWith(labelText: 'Password'),
                        validator: (val) => val.length < 6
                            ? 'Password not strong enough'
                            : null,
                        obscureText: true,
                        onChanged: (val) {
                          setState(() {
                            password = val;
                          });
                        },
                      ),
                      SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        height: 50.0,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                            elevation: 0.0,
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0)),
                            child: Text('Sign In',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16.0)),
                            onPressed: () {
                              _onSignIn();
                            }),
                      ),
                      SizedBox(height: 10.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  "Forgot Password?",
                                  style: simpleTextStyle(),
                                )),
                          )
                        ],
                      ),
                      
                         SizedBox(height: 10.0),
                      Text.rich(
                        TextSpan(
                          text: "Don't have an account? ",
                          style: TextStyle(color: Colors.white, fontSize: 14.0),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Register here',
                              style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  widget.toggleView();
                                },
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Text(error,
                          style: TextStyle(color: Colors.red, fontSize: 14.0)),
                    ],
                  ),
                ],
              ),
            ),
          ));
  }
}
