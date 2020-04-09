import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum FormType{
  login,
  signup
}

class LoginPage extends StatefulWidget {
  
  final String reset;
  LoginPage({this.reset});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {


  final _formKey = GlobalKey<FormState>();
  FormType _formType = FormType.login
  ;
  String _email;
  String _password;

  bool validateAndSave(){
    final form = _formKey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void moveToSignUp(){
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.signup;
    });
  }

  void moveToLogin(){
    _formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void _clearForm(){
    setState(() {
      _formKey.currentState.reset();
    });
  }

  void validateAndSubmit() async {
    if(validateAndSave()){
      try{
        if(_formType == FormType.login){
          final FirebaseUser user = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email,password: _password)).user;
          if(FirebaseAuth.instance.currentUser() != null){
            print('${user.email}');
          }
        }else{
          final FirebaseUser user = (await FirebaseAuth.instance.createUserWithEmailAndPassword(email: _email,password: _password)).user;
          print('${user.email}');
        }
        Navigator.of(context).pushNamed('/homepage');
      }catch(e){
        print('$e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: new Text('Login Page'),
        centerTitle: true,
        elevation: 2.0,
        leading: IconButton(
          onPressed: _clearForm,
          icon: Icon(Icons.restore),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            padding: EdgeInsets.fromLTRB(30.0,20.0,30.0,0.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _buldTextBox() + _buldButton(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buldTextBox(){
    return [
      
      TextFormField(
        decoration: InputDecoration(
          hintText: '📧 Enter Email',
          border: OutlineInputBorder(),
          ),
        validator: (value) => value.isEmpty ? '📧 Can\'t Enter empty Email ' : null,
        onSaved: (value) => _email = value.toString().trim(),
      ),

      SizedBox(height: 20.0,),

      TextFormField(
        decoration: InputDecoration(
          hintText: '😶 Enter Password',
          border: OutlineInputBorder(),
          ),
        obscureText: true,
        validator: (value) => value.isEmpty ? '😶 Can\'t Enter empty Password ' : null,
        onSaved: (value) => _password = value.toString().trim(),
      ),

      SizedBox(height: 10.0,)

    ];
  }

  List<Widget> _buldButton(){
    if(_formType == FormType.login){
      return [
        RaisedButton.icon(
          onPressed: validateAndSubmit,
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.blueAccent)),
          icon: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          label: new Text("Login",style: TextStyle(color: Colors.white),),
          color: Colors.blue,
         ),        

        SizedBox(height: 10.0,),

        new Text('If you are not registered yet ?'),

        SizedBox(height: 10.0,),

        RaisedButton.icon(
          onPressed: moveToSignUp,
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.greenAccent)),
          icon: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          label: new Text("Sign Up",style: TextStyle(color: Colors.white),),
          color: Colors.green,
         ),

      ];
    }else{
      return [
        RaisedButton.icon(
          onPressed: validateAndSubmit,
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.greenAccent)),
          icon: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          label: new Text("Sign Up",style: TextStyle(color: Colors.white),),
          color: Colors.green,
         ), 

        SizedBox(height: 10.0,),

        new Text('If you are not registered yet ?'),

        SizedBox(height: 10.0,),

        RaisedButton.icon(
          onPressed: moveToLogin,
          shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
          side: BorderSide(color: Colors.blueAccent)),
          icon: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          label: new Text("Login",style: TextStyle(color: Colors.white),),
          color: Colors.blue,
         ),

      ];
    }
  }

}