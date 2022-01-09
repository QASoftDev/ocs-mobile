import 'package:chatapp/views/ChatUsersScreen.dart';
import 'package:chatapp/views/LoginScreen.dart';

import '../views/ChatScreen.dart';

class Routes {
  //
  static routes() {
    return {
      LoginScreen.ROUTE_ID: (context) => LoginScreen(),
      ChatUsersScreen.ROUTE_ID: (context) => ChatUsersScreen(),
      ChatScreen.ROUTE_ID: (context) => ChatScreen(),
    };
  }

  static initScreen() {
    return LoginScreen.ROUTE_ID;
  }
}
