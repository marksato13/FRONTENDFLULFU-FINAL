import 'package:flutter/material.dart';

class SelectPlanProvider extends StatelessWidget {
  const SelectPlanProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Plan de Suscripción'),
      ),
      body: Center(
        child: Text('Listado de Planes de Suscripción'),
      ),
    );
  }
}
