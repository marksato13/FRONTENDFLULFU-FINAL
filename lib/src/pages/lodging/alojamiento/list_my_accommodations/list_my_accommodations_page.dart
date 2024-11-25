import 'package:flutter/material.dart';

class ListMyAccommodationsPage extends StatelessWidget {
  const ListMyAccommodationsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('mis alojamientos'),
      ),
      body: Center(
        child: const Text('Aquí puedes ver la lista de alojamientos.'),
      ),
    );
  }
}
