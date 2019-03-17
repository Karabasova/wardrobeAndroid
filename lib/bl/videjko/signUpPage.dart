import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/usermanagment.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  String _email;
  String _password;
  String _name;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      body: Form(
        key: _formKey,
        child: Center(
        child: Container(
          padding: EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: 'Username'),
                validator: (input){
                  if(input.isEmpty){
                    return 'Please type an username';
                  }else if(input.length < 2){
                    return 'Username must have at least 2 chars';
                  }
                },
                onSaved: (input) => _name = input,
              ),SizedBox(height: 15.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Email'),
                validator: (input){
                if(input.isEmpty){
                  return 'Please type an email';
                }else if(validateEmail(input)){
                  return 'Mail must be in mail format (%@%.%)';
                }
              },
                onSaved: (input) => _email = input,
              ),SizedBox(height: 15.0),
              TextFormField(
                decoration: InputDecoration(hintText: 'Password'),
                validator: (input){
                if(input.length < 6){
                  return 'Your password needs to be at least 6 characters';
                }
              },
                onSaved: (input) => _password = input,
              ),
              SizedBox(height: 5.0),
              RaisedButton(
                child: Text('Sign Up'),
                color: Colors.blue,
                textColor: Colors.white,
                elevation: 7.0,
                onPressed: signUpMethod,
              )
            ],
          ),
        ),
      ),
      )
    );
  }

  void signUpMethod() {

    if(_formKey.currentState.validate()){
      _formKey.currentState.save();
      FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: _email,
          password: _password)
          .then((signedInUser){
        UserManagement().storeNewUser(signedInUser,context,_name);
      })
          .catchError((e){
        print(e);
      });
    }else{
      debugPrint("validation not pass");
    }

  }

  bool validateEmail(String value) {
    Pattern pattern =r'^[a-zA-Z0-9\.\-\_]+\@[a-zA-Z0-9]+\.[a-zA-Z0-9]{2,}$';
    RegExp regex = new RegExp(pattern);
    if(!regex.hasMatch(value)){
      return true;
    }else{
      return false;
    }

  }
}
