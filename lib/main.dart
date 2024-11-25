import 'package:fluflu/src/pages/client/update/client_update_page.dart';
import 'package:fluflu/src/pages/client/update/assignRole/assignRole_page.dart';
import 'package:fluflu/src/pages/lodging/alojamiento/create_alojamiento/create_alojamiento_page.dart';
import 'package:fluflu/src/pages/lodging/alojamiento/list_my_accommodations/list_my_accommodations_page.dart';
import 'package:fluflu/src/pages/lodging/redireccion/rol_page.dart';
import 'package:fluflu/src/pages/lodging/suscription/payments/payments_page.dart';
import 'package:fluflu/src/pages/lodging/suscription/select_plan/select_plan_page.dart';
import 'package:fluflu/src/models/user.dart';

import 'package:flutter/material.dart';
import 'package:fluflu/src/pages/admin/todopoderoso/list/admin_todopoderoso_list_page.dart';
import 'package:fluflu/src/pages/lodging/services/list/lodging_services_list_page.dart';
import 'package:fluflu/src/pages/register/register_page.dart';
import 'package:fluflu/src/pages/roles/roles_pages.dart';
import 'package:fluflu/src/pages/login/login_page.dart';
import 'package:fluflu/src/utils/my_colors.dart';

import 'package:fluflu/src/pages/client/alojamiento/list/client_alojamiento_list_page.dart';
import 'package:fluflu/src/pages/client/alojamiento/favorites/client_favorites_page.dart';
import 'package:fluflu/src/pages/client/address/map/client_address_map_page.dart';
import 'package:fluflu/src/pages/client/messages/client_messages_page.dart';
import 'package:fluflu/src/pages/client/roomies/client_roomies_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alojamiento App Fluttercito',
      debugShowCheckedModeBanner: false,
      initialRoute: 'login',
      routes: {
        'login': (BuildContext context) => LoginPage(),
        'register': (BuildContext context) => RegisterPage(),
        'roles': (BuildContext context) => RolesPage(),

        'client/update': (BuildContext context) => ClientUpdatePage(),

        'client/update/roles': (BuildContext context) => AssignRolePage(),

        'arrendador/arrendador/list': (BuildContext context) => LodgingServicesListPage(),

        'client/alojamiento/create': (BuildContext context) => CreateAlojamientoPage(),

        '/list_my_accommodations': (BuildContext context) => ListMyAccommodationsPage(),
        '/payments': (BuildContext context) => PaymentsPage(),
        '/select_plan': (BuildContext context) => SelectPlanPage(),
        '/redireccionrol': (BuildContext context) => RolPage(),





        '/arrendador/arrendador/list': (BuildContext context) => LodgingServicesListPage(),


        'arrendador/arrendador/list': (BuildContext context) => LodgingServicesListPage(),









        'admin/mark/list': (BuildContext context) => AdminTodopoderosoListPage(),

        // Ruta para la lista de alojamientos
        'client/estudiante/list': (BuildContext context) => ClientAlojamientoListPage(),

        '/favorites': (BuildContext context) => ClientFavoritesPage(),
        '/map': (BuildContext context) => ClientAddressMapPage(),
        '/messages': (BuildContext context) => ClientMessagesPage(),
        '/roomies': (BuildContext context) => ClientRoomiesPage(),

        // Ruta para invitados
        'client/guest/list': (BuildContext context) => ClientAlojamientoListPage(isGuest: true),
      },
      theme: ThemeData(
        primarySwatch: Colors.red,
        primaryColor: MyColors.primaryColor,
      ),
    );
  }
}
