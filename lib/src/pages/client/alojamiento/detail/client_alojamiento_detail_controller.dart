import 'package:flutter/material.dart';
import 'package:fluflu/src/models/alojamiento.dart';

class ClientAlojamientoDetailController {
  late BuildContext context;
  late Function refresh;

  Alojamiento? alojamiento;

  Future<void> init(BuildContext context, Function refresh, Alojamiento alojamiento) async {
    this.context = context;
    this.refresh = refresh;
    this.alojamiento = alojamiento;  // Almacenamos los detalles del alojamiento, incluidas las categorías

    refresh();
  }
}
