// ignore_for_file: file_names, prefer_const_constructors
import 'package:flutter/material.dart';

import 'ChatScreen.dart';
import '../utils/Global.dart';
import 'LoginScreen.dart';
import '../models/User.dart';

class ChatUsersScreen extends StatefulWidget {
  ChatUsersScreen() : super();

  static const String ROUTE_ID = 'chat_users_screen';

  @override
  State<StatefulWidget> createState() => _ChatUsersScreenState();
}

class _ChatUsersScreenState extends State<ChatUsersScreen> {
  //
  List<User> _chatUsers;
  bool _connectedToSocket;
  String _connectMessage;

  @override
  void initState() {
    super.initState();
    _connectedToSocket = false;
    _connectMessage = 'conectando...';
    _chatUsers = G.getUsersFor(G.loggedInUser);
    _connectToSocket();
  }

// Funcoes
  _connectToSocket() async {
    print(
        'Conectando logado com o usuário ${G.loggedInUser.name}, ${G.loggedInUser.id}');
    G.initSocket();
    await G.socketUtils.initSocket(G.loggedInUser);
    G.socketUtils.connectToSocket();
    G.socketUtils.setOnConnectListener(onConnect);
    G.socketUtils.setOnConnectionErrorListener(onConnetionError);
    G.socketUtils.setOnConnectionTimeOutListener(onConnectionTimeout);
    G.socketUtils.setOnDisconnectListener(onDisconnect);
    G.socketUtils.setOnErrorListener(onError);
  }

  onConnect(data) {
    print('Conectado $data');
    setState(() {
      _connectedToSocket = true;
      _connectMessage = 'Conectado';
    });
  }

  onConnetionError(data) {
    print('onConnetionError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Erro de Conexão';
    });
  }

  onConnectionTimeout(data) {
    print('onConnectionTimeout $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Timeout da Conexão';
    });
  }

  onDisconnect(data) {
    print('onDisconnect $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Desconectado';
    });
  }

  onError(data) {
    print('onError $data');
    setState(() {
      _connectedToSocket = false;
      _connectMessage = 'Erro de Conexão';
    });
  }

  _openChatScreen(context) async {
    await Navigator.pushNamed(context, ChatScreen.ROUTE_ID);
  }

  _openLoginScreen(context) async {
    await Navigator.pushReplacementNamed(
      context,
      LoginScreen.ROUTE_ID,
    );
  }

  @override
  void dispose() {
    super.dispose();
    G.socketUtils.closeConnection();
  }

// Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: Text("Bate papo"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _openLoginScreen(context);
              })
        ],
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Text(''),
            Text(_connectedToSocket ? 'Conectado' : _connectMessage),
            Text(''),
            Text(
              'Clique no usuário desejado abaixo',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            Text(''),
            Expanded(
              child: ListView.builder(
                  itemCount: _chatUsers.length,
                  itemBuilder: (context, index) {
                    User user = _chatUsers[index];

                    return ListTile(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Colors.blueGrey.shade200, width: 0.5),
                          borderRadius: BorderRadius.circular(20.0)),
                      onTap: () {
                        G.toChatUser = user;
                        _openChatScreen(context);
                      },
                      title: Text(user.name),
                      subtitle: Text('ID ${user.id}, Email: ${user.email}'),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
