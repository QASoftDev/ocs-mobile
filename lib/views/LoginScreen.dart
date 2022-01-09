// ignore_for_file: file_names, prefer_const_constructors

import 'package:chatapp/views/ChatUsersScreen.dart';
import 'package:chatapp/utils/Global.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import '../models/User.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen() : super();

  static const String ROUTE_ID = 'login_screen';

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController _usernameController;
  TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
    G.initDummyUsers();
    //_updateDummy();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: Text("Vamos Conversar"),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextField(
              controller: _usernameController,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6.0)),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(20.0),
                hintText: 'Digite seu Nome',
              ),
            ),
            OutlinedButton(
                child: Text('LOGIN'),
                onPressed: () {
                  _loginBtnTap();
                }),
          ],
        ),
      ),
    );
  }

  _updateDummy() {
    String email = _usernameController.text;
    String username = _emailController.text;
    User user = User(id: _idGenerator(), name: username, email: email);

    G.insertUser(user);
  }

  _idGenerator() {
    // var uuid = Uuid();
    // return uuid.v4();
    final _random = new Random();
    int next(int min, int max) => min + _random.nextInt(max - min);
    return next(1, 100000);
  }

  _loginBtnTap() {
    if (_usernameController.text.isEmpty) {
      return;
    }
    User me = G.dummyUsers[0];

    if (_usernameController.text != 'Rodrigo') {
      me = G.dummyUsers[1];
    }

    G.loggedInUser = me;

    _openChatUsersListScreen(context);
  }

  _openChatUsersListScreen(context) async {
    await Navigator.pushReplacementNamed(context, ChatUsersScreen.ROUTE_ID);
  }
}
