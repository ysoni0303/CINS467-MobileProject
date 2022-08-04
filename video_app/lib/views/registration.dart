import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'login.dart';
import '../controllers/auth.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Video App!!',
      theme: new ThemeData(primarySwatch: Colors.red),
      home: new SignUp(),
    );
  }
}

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _LoginPageState();
}

enum FormType { login, register }

class _LoginPageState extends State<SignUp> {
  final TextEditingController _emailFilter = new TextEditingController();
  final TextEditingController _passwordFilter = new TextEditingController();
  final TextEditingController _usernameFilter = new TextEditingController();

  String _email = "";
  String _password = "";
  String _username = "";
  FormType _form = FormType
      .login; // our default setting is to login, and we should switch to creating an account when the user chooses to

  _LoginPageState() {
    _emailFilter.addListener(_emailListen);
    _passwordFilter.addListener(_passwordListen);
    _usernameFilter.addListener(_usernameListen);
  }

  void _emailListen() {
    if (_emailFilter.text.isEmpty) {
      _email = "";
    } else {
      _email = _emailFilter.text;
    }
  }

  void _passwordListen() {
    if (_passwordFilter.text.isEmpty) {
      _password = "";
    } else {
      _password = _passwordFilter.text;
    }
  }

  void _usernameListen() {
    if (_usernameFilter.text.isEmpty) {
      _username = "";
    } else {
      _username = _usernameFilter.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      // appBar: _buildBar(context),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: new Column(
          children: <Widget>[
            _buildTextFields(),
            _buildButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(BuildContext context) {
    return new AppBar(
      centerTitle: true,
    );
  }

  Widget _buildTextFields() {
    return new Container(
      child: Column(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 64,
                backgroundImage:
                    NetworkImage('https://i.pickadummy.com/600x400'),
                backgroundColor: Colors.blue,
              ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: () => AuthController.instance.uploadImage(),
                  icon: Icon(Icons.add_a_photo),
                ), // IconButton
              )
            ],
          ),
          SizedBox(
            height: 60,
          ),
          new Container(
            child: new TextField(
              controller: _usernameFilter,
              decoration: new InputDecoration(labelText: 'Username'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _emailFilter,
              decoration: new InputDecoration(labelText: 'Email'),
            ),
          ),
          new Container(
            child: new TextField(
              controller: _passwordFilter,
              decoration: new InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return new Container(
      child: new Column(
        children: <Widget>[
          new RaisedButton(
            child: new Text('Signup'),
            onPressed: _createAccount,
          ),
          new FlatButton(
            child: new Text('Already have an account? Tap here to login!!'),
            onPressed: _LoginPage,
          )
        ],
      ),
    );
  }

  void _createAccount() {
    print(_email);
    print(_password);
    print(_username);
    print(AuthController.instance.profilePhoto);
    AuthController.instance.registerUser(
        _username, _email, _password, AuthController.instance.profilePhoto);
  }

  void _LoginPage() {
    print('_LoginPage');
    Navigator.of(context)
        .push(MaterialPageRoute(builder: ((context) => Login())));
  }
}
