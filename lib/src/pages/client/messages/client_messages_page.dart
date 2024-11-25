import 'package:flutter/material.dart';

class ClientMessagesPage extends StatelessWidget {
  const ClientMessagesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mensajería con Propietarios'),
      ),
      body: Center(
        child: const Text('Aquí puedes comunicarte con los propietarios.'),
      ),
    );
  }
}
