import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:fluflu/src/utils/my_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluflu/src/pages/lodging/services/list/lodging_services_list_controller.dart';

class LodgingServicesListPage extends StatefulWidget {
  const LodgingServicesListPage({Key? key}) : super(key: key);

  @override
  _LodgingServicesListPageState createState() => _LodgingServicesListPageState();
}

class _LodgingServicesListPageState extends State<LodgingServicesListPage> {
  final LodgingServicesListController _con = LodgingServicesListController();
  int _selectedIndex = 0;

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
        title: const Text('Servicios '),
        leading: _menuIcon(),
      ),
      drawer: _drawer(),
      body: _buildBody(),
      bottomNavigationBar: _bottomNavigationBar(),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildInfoCard(),
          const SizedBox(height: 20),
          _buildActionButtons(),
          const SizedBox(height: 20),
          _buildSubscriptionSection(),
          const SizedBox(height: 20),
          _buildInfoFeatures(),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () => _con.onTabSelected(1),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text('Añadir  Alojamiento'),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: OutlinedButton(
            onPressed: () => _con.onTabSelected(2),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text(' Lista de Alojamientos'),
          ),
        ),
      ],
    );
  }

  Widget _buildSubscriptionSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
        border: Border.all(color: const Color(0xFF1C4786), width: 2), // Borde azul
      ),
      margin: const EdgeInsets.symmetric(vertical: 8), // Margen externo
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Date de alta gratis',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1C4786), // Azul para el título
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'El 45% de los arrendadores recibe su primera reserva en una semana.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54, // Gris para el texto secundario
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _con.goToSelectPlan,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1C4786), // Fondo del botón en azul
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5), // Bordes redondeados
                ),
                minimumSize: const Size(150, 50), // Tamaño mínimo: ancho 150 y alto 50
              ),
              child: const Text(
                'Mejorar Plan',
                style: TextStyle(color: Colors.white), // Texto en blanco
              ),
            ),

            TextButton(
              onPressed: _con.continueRegistration,
              child: const Text(
                '¿Ya habías empezado a registrarte?',
                style: TextStyle(
                  color: Color(0xFF1C4786), // Azul para el texto del botón
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(8), // Bordes redondeados
        border: Border.all(color: const Color(0xFFFFFFFF), width: 2), // Borde con primaryColor
      ),
      margin: const EdgeInsets.symmetric(vertical: 8), // Espaciado externo
      child: ListTile(
        //leading: Image.asset('assets/img/LOGO.png', width: 50, height: 50),
        title: const Text(
          '¿Eres arrendador? ¡Únete!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1C4786), // Texto del título en primaryColor
          ),
        ),
        subtitle: const Text(
          'Registra tu alojamiento y empieza a ganar dinero.',
          style: TextStyle(
            color: Colors.black54, // Color del texto del subtítulo
          ),
        ),
        trailing: TextButton(
          onPressed: _con.goToHelp,
          child: const Text(
            'Ayuda',
            style: TextStyle(
              color: Color(0xFF1C4786), // Texto del botón en primaryColor
            ),
          ),
        ),
      ),
    );
  }


  Widget _menuIcon() {
    return GestureDetector(
      onTap: _con.openDrawer,
      child: Container(
        margin: const EdgeInsets.only(left: 15),
        alignment: Alignment.centerLeft,
        child: Image.asset('assets/img/LOGO.png', width: 50, height: 50),
      ),
    );
  }

  Widget _drawer() {
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

  Widget _bottomNavigationBar() {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 10.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
              color: _selectedIndex == 0 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(0);
              setState(() {
                _selectedIndex = 0;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.add,
              color: _selectedIndex == 1 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(1);
              setState(() {
                _selectedIndex = 1;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.my_library_add,
              color: _selectedIndex == 2 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(2);
              setState(() {
                _selectedIndex = 2;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.payment,
              color: _selectedIndex == 3 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(3);
              setState(() {
                _selectedIndex = 3;
              });
            },
          ),
          IconButton(
            icon: Icon(
              Icons.select_all,
              color: _selectedIndex == 4 ? MyColors.primaryColor : Colors.grey,
            ),
            onPressed: () {
              _con.onTabSelected(4);
              setState(() {
                _selectedIndex = 4;
              });
            },
          ),
        ],
      ),
    );
  }


  // Nueva sección de características informativas
  Widget _buildInfoFeatures() {
    return Column(
      children: [
        _buildFeatureCard(
          title: "Destaca desde el primer momento",
          description: "Destaca tu alojamiento en búsquedas .",
          imagePath: "assets/img/visi.png",
        ),
        _buildFeatureCard(
          title: "Seguridad y Confianza",
          description: "Verificación de identidad para inquilinos confiables.",
          imagePath: "assets/img/2.png",
        ),
        _buildFeatureCard(
          title: "Opciones de Marketing",
          description: "Resalta tus propiedades a los usuarios adecuados.",
          imagePath: "assets/img/visi.png",
        ),
        _buildFeatureCard(
          title: "Soporte 24/7",
          description: "Asistencia siempre disponible para ayudarte.",
          imagePath: "assets/img/247.png",
        ),
      ],
    );
  }



  Widget _buildFeatureCard({
    required String title,
    required String description,
    required String imagePath,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, // Fondo blanco
        borderRadius: BorderRadius.circular(16), // Bordes redondeados
        border: Border.all(color: const Color(0xFFF3F7FB), width: 2), // Borde con primaryColor
      ),
      margin: const EdgeInsets.symmetric(vertical: 12), // Espaciado externo
      child: Padding(
        padding: const EdgeInsets.all(16.0), // Espaciado interno
        child: Row(
          children: [
            Image.asset(
              imagePath,
              width: 200,
              height: 200, // Aumenta el tamaño de la imagen
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }





  void refresh() {
    setState(() {});
  }
}
