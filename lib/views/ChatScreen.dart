// ignore_for_file: file_names

import 'dart:async';
import 'package:chatapp/views/LoginScreen.dart';
import 'package:uuid/uuid.dart';

import 'package:chatapp/tiles/ChatTitle.dart';
// ignore: unused_import
import 'package:chatapp/views/ChatUsersScreen.dart';
import 'package:chatapp/utils/Global.dart';
import 'package:chatapp/utils/SocketUtils.dart';
import 'package:flutter/material.dart';

import '../models/ChatMessageModel.dart';
import '../models/User.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen() : super();

  static const String ROUTE_ID = 'chat_screen';

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //
  List<ChatMessageModel> _chatMessages;
  User _toChatUser;
  UserOnlineStatus _userOnlineStatus;

  TextEditingController _chatTextController;
  ScrollController _chatListController;

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _removeListeners();
  }

  @override
  void initState() {
    super.initState();
    _chatMessages = List.empty();
    _chatMessages = _chatMessages.toList();
    _chatTextController = TextEditingController();
    _chatListController = ScrollController(initialScrollOffset: 0);
    _toChatUser = G.toChatUser;
    _userOnlineStatus = UserOnlineStatus.connecting;
    _initSocketListener();
    _checkOnline();
  }

//Funcoes
  _checkOnline() {
    ChatMessageModel chatMessageModel = ChatMessageModel(
      chatId: 0,
      to: _toChatUser.id,
      from: G.loggedInUser.id,
      toUserOnlineStatus: false,
      message: '',
      chatType: SocketUtils.SINGLE_CHAT,
    );
    G.socketUtils.checkOnline(chatMessageModel);
  }

  _initSocketListener() async {
    G.socketUtils.setOnChatMessageReceiverListener(onChatMessageReceived);
    G.socketUtils.setOnlineUserStatusListener(onUserStatus);
  }

  _removeListeners() async {
    G.socketUtils.setOnChatMessageReceiverListener(null);
    G.socketUtils.setOnlineUserStatusListener(null);
  }

  onUserStatus(data) {
    print('onUserStatus $data');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    setState(() {
      _userOnlineStatus = chatMessageModel.toUserOnlineStatus
          ? UserOnlineStatus.online
          : UserOnlineStatus.not_online;
    });
  }

  _sendMessageBtnTap() async {
    print('Sending message to ${_toChatUser.name}, id: ${_toChatUser.id}');
    if (_chatTextController.text.isEmpty) {
      return;
    }
    ChatMessageModel chatMessageModel = ChatMessageModel(
      chatId: 0,
      to: _toChatUser.id,
      from: G.loggedInUser.id,
      toUserOnlineStatus: false,
      message: _chatTextController.text,
      chatType: SocketUtils.SINGLE_CHAT,
      isFromMe: true,
    );
    processMessage(chatMessageModel);
    G.socketUtils.sendSingleChatMessage(chatMessageModel);
    _chatListScrollToBottom();
  }

  onChatMessageReceived(data) {
    print('onChatMessageReceived $data');
    ChatMessageModel chatMessageModel = ChatMessageModel.fromJson(data);
    chatMessageModel.isFromMe = false;
    processMessage(chatMessageModel);
    _chatListScrollToBottom();
  }

  processMessage(chatMessageModel) {
    setState(() {
      _chatMessages.add(chatMessageModel);
    });
  }

  _chatListScrollToBottom() {
    Timer(Duration(milliseconds: 100), () {
      if (_chatListController.hasClients) {
        _chatListController.animateTo(
          _chatListController.position.maxScrollExtent,
          duration: Duration(milliseconds: 100),
          curve: Curves.decelerate,
        );
      }
    });
  }

//Tela
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: ChatTitle(
          toChatUser: _toChatUser,
          userOnlineStatus: _userOnlineStatus,
        ),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: _viewLogo(),
            ),
            Expanded(
              child: ListView.builder(
                  controller: _chatListController,
                  itemCount: _chatMessages.length,
                  itemBuilder: (context, index) {
                    ChatMessageModel chatMessageModel = _chatMessages[index];
                    bool fromMe = false;
                    fromMe = chatMessageModel.isFromMe;
                    return Container(
                      padding: EdgeInsets.all(20.0),
                      margin: EdgeInsets.all(10.0),
                      alignment:
                          fromMe ? Alignment.centerRight : Alignment.topLeft,
                      color: fromMe ? Colors.green : Colors.grey,
                      child: Text(chatMessageModel.message),
                    );
                  }),
            ),
            _bottonChatArea(),
            _bottonButtonsChatArea(),
          ],
        ),
      ),
    );
  }

//Funcoes de tela

  _viewLogo() {
    return Image.asset('images/h2h_logo4.png');
  }

  _chatTextarea() {
    return Expanded(
        child: TextField(
      controller: _chatTextController,
      decoration: InputDecoration(
        enabledBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        focusedBorder:
            OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.all(10.0),
        hintText: 'Escreva sua mensagem',
      ),
    ));
  }

  _clearChatTextContoller() {
    _chatTextController.clear();
  }

  _bottonChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          _chatTextarea(),
        ],
      ),
    );
  }

  _bottonButtonsChatArea() {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                ),
                child: Text('Enviar Mensagem'),
                onPressed: () {
                  _sendMessageBtnTap();
                  _clearChatTextContoller();
                }),
          ),
          Expanded(
            child: OutlinedButton(
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0))),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10)),
                ),
                child: Text('Sair'),
                onPressed: () {
                  _returnToLoginScreen(context);
                }),
          ),

          // IconButton(
          //     onPressed: () {
          //       _sendMessageBtnTap();
          //     },
          //     icon: Icon(Icons.send))
        ],
      ),
    );
  }

  _returnToLoginScreen(context) async {
    await Navigator.pushReplacementNamed(context, LoginScreen.ROUTE_ID);
  }
}
