import 'package:flutter/material.dart';

class RolPage extends StatelessWidget {
  const RolPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('r'),
      ),
      body: Center(
        child: const Text('Aquí puedes ver la lista de alojamientos.'),
      ),
    );
  }
}
