// ignore_for_file: file_names, prefer_const_constructors

import 'dart:io';
import '../models/ChatMessageModel.dart';
import '../models/User.dart';
import 'package:adhara_socket_io/adhara_socket_io.dart';

class SocketUtils {
  //
  static String _serverIP =
      Platform.isIOS ? 'http://localhost' : 'http://10.0.2.2';

  static const int _SERVER_PORT = 6000;

  static String _connectURL = '$_serverIP:$_SERVER_PORT';

  //Eventos
  static const String _ON_MESSAGE_RECEIVED = 'receive_message';
  static const String _IS_USER_ONLINE_EVENT = 'check_online';
  static const String EVENT_SINGLE_CHAT_MESSAGE = 'single_chat_message';
  static const String EVENT_USER_ONLINE = 'is_user_connected';

  //Status
  static const int STATUS_MESSAGE_NOT_SENT = 10001;
  static const int STATUS_MESSAGE_SENT = 10002;

  // Tipo de chat
  static const String SINGLE_CHAT = 'single_chat';

  User _fromUser;

  SocketIO _socket;
  SocketIOManager _manager;

  initSocket(User fromUser) async {
    this._fromUser = fromUser;
    print('connecting... ${fromUser.name}...');
    await _init();
  }

  _init() async {
    _manager = SocketIOManager();
    _socket = await _manager.createInstance(_socketOptions());
  }

  connectToSocket() {
    if (null == _socket) {
      print('Sockt in null');
      return;
    }
    _socket.connect();
  }

  _socketOptions() {
    final Map<String, String> userMap = {
      'from': _fromUser.id.toString(),
    };
    return SocketOptions(
      _connectURL,
      enableLogging: true,
      transports: [Transports.WEB_SOCKET],
      query: userMap,
    );
  }

  setOnConnectListener(Function onConnect) {
    _socket.onConnect;
  }

  setOnConnectionTimeOutListener(Function onConnectionTimeout) {
    _socket.onConnectTimeout;
  }

  setOnConnectionErrorListener(Function onConnetionError) {
    _socket.onConnectError;
  }

  setOnErrorListener(Function onError) {
    _socket.onError;
  }

  setOnDisconnectListener(Function onDisconnect) {
    _socket.onConnect;
  }

  closeConnection() {
    if (null != _socket) {
      print('Closing Connection');
      _manager.clearInstance(_socket);
    }
  }

  sendSingleChatMessage(ChatMessageModel chatMessageModel) {
    if (null == _socket) {
      print('Cannot send a message');
      return;
    }
    _socket.emit(EVENT_SINGLE_CHAT_MESSAGE, [chatMessageModel.toJson()]);
  }

  setOnChatMessageReceiverListener(Function onMessageReceived) {
    if (onMessageReceived == null) {
      return;
    }
    _socket.on(_ON_MESSAGE_RECEIVED, (data) {
      onMessageReceived(data);
    });
  }

  setOnlineUserStatusListener(Function onUserStatus) {
    if (onUserStatus == null) {
      return;
    }
    _socket.on(EVENT_USER_ONLINE, (data) {
      onUserStatus(data);
    });
  }

  checkOnline(ChatMessageModel chatMessageModel) {
    print('Checking Onliner User: ${chatMessageModel.to}');
    if (null == _socket) {
      print('Cannot check online');
      return;
    }
    _socket.emit(_IS_USER_ONLINE_EVENT, [chatMessageModel.toJson()]);
  }
}
