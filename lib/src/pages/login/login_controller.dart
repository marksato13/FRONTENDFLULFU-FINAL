import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/provider/users_provider.dart';
import 'package:fluflu/src/utils/my_snackbar.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:flutter/material.dart';
import 'package:fluflu/src/models/user.dart';

class LoginController {
  late BuildContext context;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  UsersProvider usersProvider = UsersProvider();
  SharedPref _sharedPref = SharedPref();
  bool _isInitialized = false;

  Future<void> init(BuildContext context) async {
    if (_isInitialized) return;
    _isInitialized = true;
    this.context = context;
    await usersProvider.init(context);
    User? user = await _sharedPref.loadUser();

    if (user != null && user.sessionToken.isNotEmpty) {
      navigateBasedOnRoles(user);
    }
  }

  void navigateBasedOnRoles(User user) {
    if (user.roles.length > 1) {
      Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
    } else if (user.roles.isNotEmpty) {
      Navigator.pushNamedAndRemoveUntil(
          context, user.roles[0].route, (route) => false);
    }
  }

  void goToRegisterPage() {
    Navigator.pushNamed(context, 'register');
  }

  void login() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Validación de campos vacíos
    if (email.isEmpty || password.isEmpty) {
      MySnackbar.showErrorValidacionCampos(
          context, "Debes ingresar email y contraseña");
      return;
    }

    // Intentar login
    ResponseApi responseApi = await usersProvider.login(email, password);

    if (responseApi.success) {
      User user = User.fromJson(responseApi.data);
      _sharedPref.saveUser(user);
      navigateBasedOnRoles(user);
      MySnackbar.showSuccess(context, "Login exitoso");
    } else {
      // Manejo de errores según los mensajes que envía el backend
      if (responseApi.message == 'El email no fue encontrado') {
        MySnackbar.showErrorAcceso(context, "El email ingresado no existe");
      } else if (responseApi.message == 'La contraseña es incorrecta') {
        MySnackbar.showErrorAcceso(
            context, "La contraseña es incorrecta, por favor intenta de nuevo");
      } else {
        MySnackbar.showProblemasServidor(
            context, "Problema con el servidor, intenta más tarde");
      }
    }
  }

  // Nueva función para el modo invitado
  void loginAsGuest() {
    // Aquí estamos redireccionando a la ruta para invitados
    Navigator.pushNamed(context, 'client/guest/list');
  }
}
