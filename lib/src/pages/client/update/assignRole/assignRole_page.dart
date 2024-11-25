import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';  // Importa el paquete de Lottie
import 'package:fluflu/src/pages/client/update/assignRole/assignRole_controller.dart';

class AssignRolePage extends StatefulWidget {
  @override
  _AssignRolePageState createState() => _AssignRolePageState();
}

class _AssignRolePageState extends State<AssignRolePage> {
  AssignRoleController _assignRoleController = AssignRoleController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Center(  // Utilizamos Center para centrar todo
        child: Column(
          mainAxisSize: MainAxisSize.min,  // Ajustar el tamaño del Column al contenido
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Animación Lottie centrada y más grande
            Lottie.asset(
              'assets/json/animation.json',  // Ruta al archivo JSON de la animación
              width: 300,  // Ajusté el tamaño más grande
              height: 300,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 90),  // Espaciado entre la animación y el texto

            // Información sobre las funciones del arrendador
            Text(
              '¡Bienvenido al rol Arrendador!',
              style: TextStyle(
                fontSize: 24,  // Tamaño de letra grande
                fontWeight: FontWeight.bold,
                color: Colors.blue,  // Color vivo para el título
              ),
            ),
            SizedBox(height: 10),

            Text(
              'Podrás subir y gestionar tus alojamientos',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black,  // Texto en color negro
              ),
            ),
            SizedBox(height: 5),

            Text(
              'Tienes la capacidad de subir alojamientos de',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,  // Texto en color ligeramente gris oscuro
              ),
            ),
            Text(
              'diferentes tamaños y estilos',
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,  // Texto en color ligeramente gris oscuro
              ),
            ),
            SizedBox(height: 10),

            Text(
              '¡Es tu oportunidad de destacar!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orangeAccent,  // Color vivo y resaltado
              ),
            ),
            SizedBox(height: 30),  // Espaciado extra antes del botón

            // Botón de continuar como arrendador centrado
            ElevatedButton(
              onPressed: () async {
                await _assignRoleController.assignArrendadorRole(context);
              },
              child: const Text(
                'Beneficios',
                style: TextStyle(
                  fontSize: 18,  // Hacemos el texto del botón más grande
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,  // Cambié primary a backgroundColor
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
