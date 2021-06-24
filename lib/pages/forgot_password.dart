import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wamm/shared/constants.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

TextStyle simpleTextStyle() {
  return TextStyle(color: Colors.white, fontSize: 16);
}

String email;
FirebaseAuth auth = FirebaseAuth.instance;

class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Forgot Password?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 23.0,
                  fontWeight: FontWeight.bold)),
          backgroundColor: Colors.black,
          elevation: 0.0,
        ),
        body: Form(
          child: Container(
            color: Colors.black,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
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
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50.0,
                    // ignore: deprecated_member_use
                    child: RaisedButton(
                        elevation: 0.0,
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        child: Text('Forgot Password',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.0)),
                        onPressed: () {
                          auth.sendPasswordResetEmail(email: email);
                          Navigator.of(context).pop();
                        }),

                    //Text(
                    // 'To Reset your Password, Contact our Admin at "muizzbutt79@gmail.com"',
                    //  textAlign: TextAlign.center,
                    ///  style: TextStyle(
                    ////     color: Colors.white,
                    //    fontSize: 16,
                    //     fontFamily: 'OverpassRegular',
                    //    fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
