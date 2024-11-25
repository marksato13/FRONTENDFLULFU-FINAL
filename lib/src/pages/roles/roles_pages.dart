import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluflu/src/models/rol.dart';
import 'package:fluflu/src/pages/roles/roles_controller.dart';
import 'package:fluflu/src/utils/my_colors.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({Key? key}) : super(key: key);

  @override
  _RolesPageState createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  RolesController _con = RolesController();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un rol'),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Container(
        margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.14),
        child: ListView(
          children: _con.user != null && _con.user!.roles.isNotEmpty
              ? _con.user!.roles.map((Rol rol) {
            return _cardRol(rol);
          }).toList()
              : [const Center(child: Text('No hay roles disponibles'))],
        ),
      ),
    );
  }

  Widget _cardRol(Rol rol) {
    return GestureDetector(
      onTap: () => _con.goToPage(rol.route),
      child: Column(
        children: [
          Container(
            height: 100,
            child: FadeInImage(
              image: rol.image.isNotEmpty
                  ? NetworkImage(rol.image)
                  : const AssetImage('assets/img/no-image.png') as ImageProvider,
              fit: BoxFit.contain,
              fadeInDuration: const Duration(milliseconds: 50),
              placeholder: const AssetImage('assets/img/no-image.png'),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            rol.name,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
