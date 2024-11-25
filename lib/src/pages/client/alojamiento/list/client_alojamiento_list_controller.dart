import 'package:fluflu/src/models/service.dart';
import 'package:flutter/material.dart';
import 'package:fluflu/src/models/alojamiento.dart';
import 'package:fluflu/src/models/user.dart';
import 'package:fluflu/src/provider/alojamiento_provider.dart';
import 'package:fluflu/src/utils/shared_pref.dart';
import 'package:fluflu/src/pages/client/alojamiento/detail/client_alojamiento_detail_page.dart';  // Importa la página de detalles

class ClientAlojamientoListController {
  late BuildContext context;
  late Function refresh;
  List<Alojamiento> alojamientos = [];
  List<Map<String, dynamic>> categorias = []; // Lista de categorías
  List<Service> services = []; // Lista de servicios
  User? user;
  bool isGuest = false;
  bool isArrendador = false;

  SharedPref _sharedPref = SharedPref();
  GlobalKey<ScaffoldState> key = GlobalKey<ScaffoldState>();
  AlojamientoProvider _alojamientoProvider = AlojamientoProvider();



  Future<void> init(BuildContext context, Function refresh, {bool isGuest = false}) async {
    this.context = context;
    this.refresh = refresh;
    this.isGuest = isGuest;
    if (!isGuest) {
      user = User.fromJson(await _sharedPref.read('user'));
      _alojamientoProvider.init(context, user!);

      isArrendador = user?.roles.any((role) => role.id == '2') ?? false;
    }
    print('Es invitado: $isGuest');
    await getAlojamientos();
    refresh();
  }




  /// Método para cargar las categorías y servicios
  Future<void> loadCategoriasAndServices() async {
    try {
      categorias = await _alojamientoProvider.getAllCategorias();
      services = await _alojamientoProvider.getAllServices();

      if (categorias.isEmpty) {
        print('No se encontraron categorías.');
      } else {
        print('Categorías cargadas: ${categorias.length}');
      }

      if (services.isEmpty) {
        print('No se encontraron servicios.');
      } else {
        print('Servicios cargados: ${services.length}');
      }

      refresh();
    } catch (e) {
      print('Error al cargar categorías o servicios: $e');
    }
  }

  /// Método para filtrar alojamientos
  Future<void> filterAlojamientos({String? categoriaId, List<int>? serviceIds}) async {
    try {
      print('Iniciando el filtro de alojamientos...');
      alojamientos = await _alojamientoProvider.findByFilters(
        categoriaId: categoriaId,
        serviceIds: serviceIds,
      );
      print('Alojamientos filtrados: ${alojamientos.length}');
      refresh();
    } catch (e) {
      print('Error al filtrar alojamientos: $e');
    }
  }

  Future<void> getAlojamientos() async {
    try {
      print('Iniciando la solicitud de alojamientos...');
      alojamientos = await _alojamientoProvider.getAll(isGuest: isGuest);
      print('Alojamientos obtenidos: ${alojamientos.length}');
      refresh();
    } catch (e) {
      print('Error al obtener alojamientos: $e');
    }
  }

  void applyFilter() async {
    // Supongamos que tienes un formulario o seleccionadores en tu página para obtener estos valores
    String? selectedCategoriaId = '1'; // ID de categoría seleccionada
    List<int> selectedServiceIds = [2, 3]; // IDs de servicios seleccionados

    await filterAlojamientos(
      categoriaId: selectedCategoriaId,
      serviceIds: selectedServiceIds,
    );
  }


  void goToAlojamientoDetail(Alojamiento alojamiento) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClientAlojamientoDetailPage(alojamiento: alojamiento),
      ),
    );
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

  void goToUpdatePage() {
    Navigator.pushNamed(context, 'client/update');
  }

  void goToAssignRole() {
    Navigator.pushNamed(context, 'client/update/roles');
  }


  void goToRoles() {
    Navigator.pushNamedAndRemoveUntil(context, 'roles', (route) => false);
  }

  void onTabSelected(int index) {
    switch (index) {
      case 0:
        Navigator.pushNamed(context, 'client/estudiante/list');
        break;
      case 1:
        Navigator.pushNamed(context, '/map');
        break;
      case 2:
        Navigator.pushNamed(context, '/favorites');
        break;
      case 3:
        Navigator.pushNamed(context, '/messages');
        break;
      case 4:
        try {
          print("Redirigiendo a /arrendador/arrendador/list");
          Navigator.pushNamed(context, '/arrendador/arrendador/list');
        } catch (e) {
          print('Error al redirigir: $e');
        }
        break;

      default:
        Navigator.pushNamed(context, 'client/estudiante/list');
        break;
    }
  }
}
