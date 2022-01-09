// @dart=2.9
// ignore_for_file: file_names, prefer_const_constructors
import 'SocketUtils.dart';
import '../models/User.dart';

class G {
  static List<User> dummyUsers = [];

  static User loggedInUser;

  static User toChatUser;

  static SocketUtils socketUtils;

  static void initDummyUsers() {
    User userA = User(id: 1000, name: 'Rodrigo', email: 'rodrigo@gmail.com');
    User userB = User(id: 1001, name: 'Carlos', email: 'carlos@gmail.com');
    dummyUsers = [];
    dummyUsers.add(userA);
    dummyUsers.add(userB);
  }

  static void insertUser(User user) {
    //dummyUsers = [];
    dummyUsers.add(user);
  }

  static List<User> getUsersFor(User user) {
    List<User> filteredUsers = dummyUsers
        .where(
          (u) => (!u.name.toLowerCase().contains(
                user.name.toLowerCase(),
              )),
        )
        .toList();
    return filteredUsers;
  }

  static initSocket() {
    if (null == socketUtils) {
      socketUtils = SocketUtils();
    }
  }
}
