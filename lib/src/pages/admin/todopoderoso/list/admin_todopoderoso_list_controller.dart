import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/models/user.dart';

class AdminTodopoderosoListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key =new GlobalKey<ScaffoldState>();

  List<User> users = [];

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh =refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    refresh();

  }

  void logout() {
    _sharedPref.logout(context, user!.id);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  void openDrawer() {
    if (key.currentState != null) {
      key.currentState!.openDrawer();
    }
  }

  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

}
