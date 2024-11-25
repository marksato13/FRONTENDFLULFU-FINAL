import 'package:fluflu/src/pages/lodging/alojamiento/create_alojamiento/create_alojamiento_page.dart';
import 'package:flutter/material.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/provider/subscription_provider.dart';

class LodgingServicesListController {
  late BuildContext context;
  late Function refresh;
  User? user;
  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();

  // Instancia del provider de suscripciones
  final SubscriptionProvider _subscriptionProvider = SubscriptionProvider();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    user = User.fromJson(await _sharedPref.read('user'));
    if (user == null) {
      // Maneja el caso cuando el usuario no está autenticado
      Navigator.pushNamed(context, '/login');
    } else {
      refresh();
    }
  }


  // Función para abrir el menú lateral
  void openDrawer() {
    if (key.currentState != null) {
      key.currentState!.openDrawer();
    }
  }

  // Función para cerrar sesión
  void logout() {
    _sharedPref.logout(context, user!.id);
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  // Navegar a la página de roles
  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  // Navegar a la ayuda
  void goToHelp() {
    Navigator.pushNamed(context, '/help');
  }

  // Navegar a la selección de plan de suscripción
  void goToSelectPlan() {
    Navigator.pushNamed(context, '/select_plan');
  }

  // Continuar el registro en caso de que el usuario ya haya empezado
  void continueRegistration() {
    Navigator.pushNamed(context, '/client/estudiante/list');
  }

  // Método para manejar la selección de las pestañas en el BottomNavigationBar
  void onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'arrendador/arrendador/list');
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CreateAlojamientoPage(),
          ),
        );
        break;
      case 2: // Redirección al listado de alojamientos de estudiantes
        Navigator.pushNamed(context, 'client/estudiante/list');
        break;
      case 3:
        Navigator.pushNamed(context, '/payments');
        break;
      case 4:
        goToSelectPlan();
        break;
      default:
        Navigator.pushNamed(context, 'arrendador/arrendador/list');
        break;
    }
  }
}
