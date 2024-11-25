import 'package:flutter/material.dart';

class ClientRoomiesPage extends StatelessWidget {
  const ClientRoomiesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Roomies'),
      ),
      body: Center(
        child: const Text('Aquí puedes buscar compañeros de cuarto.'),
      ),
    );
  }
}
