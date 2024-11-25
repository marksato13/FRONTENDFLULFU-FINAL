import 'package:flutter/material.dart';

class ClientFavoritesPage extends StatelessWidget {
  const ClientFavoritesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alojamientos Favoritos'),
      ),
      body: Center(
        child: const Text('Aquí se mostrarán los alojamientos que has guardado como favoritos.'),
      ),
    );
  }
}
