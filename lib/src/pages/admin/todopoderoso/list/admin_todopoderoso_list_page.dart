import 'package:fluflu/src/utils/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluflu/src/pages/admin/todopoderoso/list/admin_todopoderoso_list_controller.dart';

class AdminTodopoderosoListPage extends StatefulWidget {
  const AdminTodopoderosoListPage({Key? key}) : super(key: key);

  @override
  _AdminTodopoderosoListPageState createState() => _AdminTodopoderosoListPageState();
}

class _AdminTodopoderosoListPageState extends State<AdminTodopoderosoListPage> {
  final AdminTodopoderosoListController _con = AdminTodopoderosoListController();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _con.key,
      appBar: AppBar(
        leading: _menucajita(),
      ),
      drawer: _cajita(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text('Lista de Alojamiento para Clientes'),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }


  Widget _menucajita() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 20),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/menu.png', width: 20, height: 20),
      ),
    );
  }

  Widget _cajita() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: MyColors.primaryColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_con.user?.name ?? ''} ${_con.user?.lastname ?? ''}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.email ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Text(
                  _con.user?.phone ?? '',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                  maxLines: 1,
                ),
                Container(
                  height: 40,
                  margin: const EdgeInsets.only(top: 10),
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/img/no-image.png'),
                    image: _con.user?.image != null && _con.user!.image.isNotEmpty
                        ? NetworkImage(_con.user!.image) as ImageProvider
                        : const AssetImage('assets/img/no-image.png'),
                    fit: BoxFit.contain,
                    fadeInDuration: const Duration(milliseconds: 50),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Editar perfil'),
            trailing: const Icon(Icons.edit_outlined),
          ),
          ListTile(
            title: const Text('Mis alojamientos'),
            trailing: const Icon(Icons.home_sharp),
          ),
          // Corrección del operador ternario
          if (_con.user != null && (_con.user!.roles?.length ?? 0) > 1)
            ListTile(
              onTap: _con.goToRoles,
              title: const Text('Seleccionar rol'),
              trailing: const Icon(Icons.person_2_outlined),
            ),
          ListTile(
            onTap: _con.logout,
            title: const Text('Cerrar sesión'),
            trailing: const Icon(Icons.power_settings_new),
          ),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
