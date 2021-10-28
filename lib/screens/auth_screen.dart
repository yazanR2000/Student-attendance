import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

enum AuthState { LOGIN, SIGNUP }

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState ( );
}

class _AuthScreenState extends State<AuthScreen> {

  bool _isLoading = false;
  AuthState _state = AuthState.LOGIN;
  final _formKey = GlobalKey<FormState> ( );
  Map<String, String> _info = {'Full_name': '', 'Email': '', 'Password': ''};

  Future _authUser() async {
    if (_formKey.currentState!.validate ( )) {
      setState ( () {
        _isLoading = true;
      } );
      if (_state == AuthState.LOGIN)
        await Provider.of<Auth> ( context, listen: false )
            .logIn ( _info['Email']!, _info['Password']! );
      else
        await Provider.of<Auth> ( context, listen: false )
            .signUp ( _info['Email']!, _info['Password']! );
      setState ( () {
        _isLoading = false;
      } );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Colors.white,
      body: _isLoading
          ? Center (
        child: CircularProgressIndicator ( ),
      )
          : Row (
        children: [
          Expanded (
            flex: 2,
            child: Container (
              height: double.infinity,
              //color: Colors.black,
              child: Center (
                child: Image.asset (
                  'assets/Logo.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Expanded (
            flex: 3,
            child: Container (
              padding: EdgeInsets.symmetric ( vertical: 10, horizontal: 20 ),
              height: double.infinity,
              child: Center (
                child: Form (
                  key: _formKey,
                  child: SingleChildScrollView (
                    child: Column (
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (_state == AuthState.SIGNUP)
                          Text (
                            'Sign up',
                            style: TextStyle (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30 ),
                          ),
                        if (_state == AuthState.LOGIN)
                          Text (
                            'Login',
                            style: TextStyle (
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 30 ),
                          ),
                        SizedBox (
                          height: 25,
                        ),
                        if (_state == AuthState.SIGNUP)
                          Text (
                            'Full name :',
                            style: TextStyle (
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (_state == AuthState.SIGNUP)
                          SizedBox (
                            height: 10,
                          ),
                        if (_state == AuthState.SIGNUP)
                          Container (
                            padding: EdgeInsets.symmetric (
                                horizontal: 10 ),
                            decoration: BoxDecoration (
                                color: Colors.grey.shade100,
                                borderRadius:
                                BorderRadius.circular ( 5 ) ),
                            child: TextFormField (
                              initialValue: '',
                              validator: (value) {
                                if (value!.isEmpty)
                                  return 'Please enter your Full name';
                                return null;
                              },
                              onSaved: (value) {
                                _info['Full_name'] = value!;
                              },
                              decoration: InputDecoration (
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        if (_state == AuthState.SIGNUP)
                          SizedBox (
                            height: 20,
                          ),
                        Text (
                          'Email :',
                          style: TextStyle (
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox (
                          height: 10,
                        ),
                        Container (
                          padding:
                          EdgeInsets.symmetric ( horizontal: 10 ),
                          decoration: BoxDecoration (
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular ( 5 ),
                          ),
                          child: TextFormField (
                            initialValue: '',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              _info['Email'] = value!;
                            },
                            decoration: InputDecoration (
                              border: InputBorder.none,
                            ),
                            keyboardType:
                            TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox (
                          height: 20,
                        ),
                        Text (
                          'Password :',
                          style: TextStyle (
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox (
                          height: 10,
                        ),
                        Container (
                          padding:
                          EdgeInsets.symmetric ( horizontal: 10 ),
                          decoration: BoxDecoration (
                              color: Colors.grey.shade100,
                              borderRadius:
                              BorderRadius.circular ( 5 ) ),
                          child: TextFormField (
                            initialValue: '',
                            validator: (value) {
                              if (value!.isEmpty)
                                return 'Please enter your password';
                              return null;
                            },
                            onSaved: (value) {
                              _info['Password'] = value!;
                            },
                            decoration: InputDecoration (
                              border: InputBorder.none,
                            ),
                            obscureText: true,
                          ),
                        ),
                        if (_state == AuthState.SIGNUP)
                          SizedBox (
                            height: 20,
                          ),
                        if (_state == AuthState.SIGNUP)
                          Text (
                            'Confirm password :',
                            style: TextStyle (
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        if (_state == AuthState.SIGNUP)
                          SizedBox (
                            height: 10,
                          ),
                        if (_state == AuthState.SIGNUP)
                          Container (
                            padding: EdgeInsets.symmetric (
                                horizontal: 10 ),
                            decoration: BoxDecoration (
                                color: Colors.grey.shade100,
                                borderRadius:
                                BorderRadius.circular ( 5 ) ),
                            child: TextFormField (
                              initialValue: '',
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please confirm your password';
                                }
                                return null;
                              },
                              decoration: InputDecoration (
                                border: InputBorder.none,
                              ),
                              obscureText: true,
                            ),
                          ),
                        SizedBox (
                          height: 20,
                        ),
                        Row (
                          children: [
                            Expanded (
                              child: ElevatedButton (
                                onPressed: () {
                                  _formKey.currentState!.save ( );
                                  _authUser ( );
                                },
                                child: Text (
                                  _state == AuthState.LOGIN
                                      ? 'LOGIN'
                                      : 'SIGN UP',
                                  style: TextStyle (
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom (
                                  //primary: Colors.black,
                                    padding: EdgeInsets.symmetric (
                                        vertical: 20 ) ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox (
                          height: 20,
                        ),
                        Row (
                          children: [
                            Text ( _state == AuthState.LOGIN
                                ? 'Don\'t have an account ? '
                                : 'Already have an account ?' ),
                            TextButton (
                              onPressed: () {
                                setState ( () {
                                  if (_state == AuthState.LOGIN)
                                    _state = AuthState.SIGNUP;
                                  else {
                                    _state = AuthState.LOGIN;
                                  }
                                } );
                              },
                              child: Text (
                                _state == AuthState.LOGIN
                                    ? 'Sign up'
                                    : 'Log in',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
