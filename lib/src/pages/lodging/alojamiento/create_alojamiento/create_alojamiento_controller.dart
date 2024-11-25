import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/provider/newalojamiento_provider.dart';
import 'package:fluflu/src/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateAlojamientoController {
  late BuildContext context;
  late Function refresh;

  // Controladores de los campos
  TextEditingController nombreAlojamientoController = TextEditingController();
  TextEditingController descripcionController = TextEditingController();
  TextEditingController direccionController = TextEditingController();
  TextEditingController precioController = TextEditingController();
  TextEditingController neighborhoodController = TextEditingController();
  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();
  TextEditingController placeIdController = TextEditingController();
  TextEditingController paisController = TextEditingController();
  TextEditingController estadoController = TextEditingController();
  TextEditingController ciudadController = TextEditingController();
  TextEditingController codigoPostalController = TextEditingController();
  TextEditingController categoriaController = TextEditingController();

  // Gestión de imágenes
  final ImagePicker _picker = ImagePicker();
  String? selectedCategoriaId; // ID de la categoría seleccionada

  List<File> images = [];

  // Gestión de servicios
  List<String> selectedServices = [];

  final NewAlojamientoProvider _provider = NewAlojamientoProvider();

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;
    await _provider.init(context);
  }

  Future<void> selectImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      images = pickedImages.map((file) => File(file.path)).toList();
      refresh();
    }
  }

  Future<void> createAlojamiento() async {
    String nombre = nombreAlojamientoController.text.trim();
    String descripcion = descripcionController.text.trim();
    String direccion = direccionController.text.trim();
    String precio = precioController.text.trim();
    String neighborhood = neighborhoodController.text.trim();
    String lat = latController.text.trim();
    String lng = lngController.text.trim();
    String placeId = placeIdController.text.trim();
    String pais = paisController.text.trim();
    String estado = estadoController.text.trim();
    String ciudad = ciudadController.text.trim();
    String codigoPostal = codigoPostalController.text.trim();
    String categoria = categoriaController.text.trim();

    // Validaciones de los campos
    // Validaciones de los campos
    if (nombre.isEmpty) {
      MySnackbar.show(context, 'El nombre del alojamiento es obligatorio.', Colors.red);
      return;
    }
    if (descripcion.isEmpty) {
      MySnackbar.show(context, 'La descripción es obligatoria.', Colors.red);
      return;
    }
    if (direccion.isEmpty) {
      MySnackbar.show(context, 'La dirección es obligatoria.', Colors.red);
      return;
    }
    if (precio.isEmpty || double.tryParse(precio) == null || double.parse(precio) <= 0) {
      MySnackbar.show(context, 'El precio debe ser un número válido mayor a 0.', Colors.red);
      return;
    }
    if (lat.isEmpty || lng.isEmpty) {
      MySnackbar.show(context, 'Las coordenadas (latitud y longitud) son obligatorias.', Colors.red);
      return;
    }
    if (double.tryParse(lat) == null || double.tryParse(lng) == null) {
      MySnackbar.show(context, 'Las coordenadas deben ser números válidos.', Colors.red);
      return;
    }
    if (double.parse(lat).abs() > 90 || double.parse(lng).abs() > 180) {
      MySnackbar.show(context, 'Las coordenadas están fuera del rango permitido.', Colors.red);
      return;
    }
    if (selectedCategoriaId == null) {
      MySnackbar.show(context, 'Debe seleccionar una categoría.', Colors.red);
      return;
    }
    if (selectedServices.isEmpty) {
      MySnackbar.show(context, 'Debe seleccionar al menos un servicio.', Colors.red);
      return;
    }
    if (images.isEmpty) {
      MySnackbar.show(context, 'Debe incluir al menos una imagen.', Colors.red);
      return;
    }
    double precioValue = double.tryParse(precio) ?? 0.0;
    double latValue = double.tryParse(lat) ?? 0.0;
    double lngValue = double.tryParse(lng) ?? 0.0;

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Creando alojamiento...');

    // Crear el alojamiento
    ResponseApi response = await _provider.createAlojamiento(
      //idUser: "1", // Cambiar a la ID del usuario autenticado
      nombreAlojamiento: nombre,
      descripcion: descripcion,
      direccion: direccion,
      precio: precioValue,
      neighborhood: neighborhood,
      lat: latValue,
      lng: lngValue,
      placeId: placeId,
      pais: pais,
      estado: estado,
      ciudad: ciudad,
      codigoPostal: codigoPostal,
      idCategoria: selectedCategoriaId!, // Usar ID de categoría seleccionada
      images: images,
      serviceIds: selectedServices, // Agregar los servicios seleccionados

    );

    progressDialog.close();

    if (response.success) {
      MySnackbar.show(
        context,
        'Alojamiento creado correctamente.',
        Colors.green,
      );
      Navigator.pop(context);
    } else {
      MySnackbar.show(
        context,
        'Error: ${response.message}',
        Colors.red,
      );
    }
  }
}
