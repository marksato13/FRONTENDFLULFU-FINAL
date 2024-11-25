import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/provider/newalojamiento_provider.dart';
import 'package:fluflu/src/provider/ServiceProvider.dart';

import 'package:fluflu/src/utils/my_colors.dart';
import 'package:fluflu/src/utils/my_snackbar.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class CreateAlojamientoPage extends StatefulWidget {
  const CreateAlojamientoPage({Key? key}) : super(key: key);

  @override
  _CreateAlojamientoPageState createState() => _CreateAlojamientoPageState();
}

class _CreateAlojamientoPageState extends State<CreateAlojamientoPage> {
  final NewAlojamientoProvider _provider = NewAlojamientoProvider();
  final ImagePicker _picker = ImagePicker();

  List<File> _images = [];
  final TextEditingController _nombreAlojamientoController = TextEditingController();
  final TextEditingController _descripcionController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  final TextEditingController _categoriaController = TextEditingController();

  String? _selectedCategoriaId; // ID de la categoría seleccionada
  List<Map<String, dynamic>> _availableCategorias = []; // Lista de categorías disponibles


  List<Map<String, dynamic>> _availableServices = []; // Lista de servicios disponibles
  List<String> _selectedServiceIds = []; // Lista de IDs de servicios seleccionados

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _provider.init(context);
      _loadCategorias(); // Cargar categorías disponibles

      _loadServices(); // Cargar servicios disponibles

    });
  }


  Future<void> _loadServices() async {
    try {
      final response = await _provider.getAllServices();
      setState(() {
        _availableServices = response
            .map((service) => {'id': service.id, 'name': service.nombre})
            .toList();
      });
    } catch (e) {
      MySnackbar.show(context, 'Error al cargar los servicios: $e', MyColors.errorColor);
    }
  }


  Future<void> _loadCategorias() async {
    try {
      final categorias = await _provider.getAllCategorias();
      if (categorias.isEmpty) {
        MySnackbar.show(context, 'No se encontraron categorías disponibles.', MyColors.validationColor);
      }
      setState(() {
        _availableCategorias = categorias;
      });
    } catch (e) {
      MySnackbar.show(context, 'Error al cargar las categorías: $e', MyColors.errorColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Alojamiento'),
        backgroundColor: MyColors.primaryColor,
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              _textFieldNombreAlojamiento(),
              _textFieldDescripcion(),
              _textFieldDireccion(),
              _textFieldPrecio(),
              _dropdownCategoria(), // Selector de categoría
              _servicesSelector(), // Selector de servicios
              _imageSelector(),
              _imagePreview(),
              _buttonCrearAlojamiento(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textFieldNombreAlojamiento() {
    return _buildTextField(
      controller: _nombreAlojamientoController,
      hintText: 'Nombre del Alojamiento',
      icon: Icons.home,
    );
  }

  Widget _textFieldDescripcion() {
    return _buildTextField(
      controller: _descripcionController,
      hintText: 'Descripción',
      icon: Icons.description,
    );
  }

  Widget _textFieldDireccion() {
    return _buildTextField(
      controller: _direccionController,
      hintText: 'Dirección',
      icon: Icons.location_on,
    );
  }

  Widget _textFieldPrecio() {
    return _buildTextField(
      controller: _precioController,
      hintText: 'Precio',
      icon: Icons.monetization_on,
      keyboardType: TextInputType.number,
    );
  }


  Widget _dropdownCategoria() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: _selectedCategoriaId,
          hint: const Text('Selecciona una categoría'),
          items: _availableCategorias.map((categoria) {
            return DropdownMenuItem<String>(
              value: categoria['id'].toString(),
              child: Text(categoria['nombre']),
            );
          }).toList(),
          onChanged: (String? newValue) {
            setState(() {
              _selectedCategoriaId = newValue;
            });
          },
        ),
      ),
    );
  }


  Widget _servicesSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecciona Servicios:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: _openServicesModal, // Llama a la función que abre el modal
            child: const Text('Seleccionar Servicios'),
            style: ElevatedButton.styleFrom(
              backgroundColor: MyColors.primaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _selectedServiceIds.map((id) {
              final service = _availableServices.firstWhere((s) => s['id'] == id);
              return Chip(
                label: Text(service['name']),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () {
                  setState(() {
                    _selectedServiceIds.remove(id);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  void _openServicesModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.9,
          builder: (BuildContext context, ScrollController scrollController) {
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Selecciona Servicios',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close, color: Colors.grey),
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: _availableServices.length,
                      itemBuilder: (context, index) {
                        final service = _availableServices[index];
                        final isSelected = _selectedServiceIds.contains(service['id']);
                        return CheckboxListTile(
                          title: Text(
                            service['name'] ?? '',
                            style: const TextStyle(fontSize: 16),
                          ),
                          value: isSelected,
                          onChanged: (bool? selected) {
                            setState(() {
                              if (selected == true) {
                                _selectedServiceIds.add(service['id']);
                              } else {
                                _selectedServiceIds.remove(service['id']);
                              }
                            });
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Cerrar el modal
                    },
                    child: const Text(
                      'Aplicar',
                      style: TextStyle(fontSize: 16),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }






  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
      decoration: BoxDecoration(
        color: MyColors.primaryOpacityColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(15),
          hintStyle: TextStyle(color: MyColors.primaryColoDark),
          prefixIcon: Icon(icon, color: MyColors.primaryColor),
        ),
      ),
    );
  }

  Widget _imageSelector() {
    return GestureDetector(
      onTap: _selectImages,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        child: CircleAvatar(
          radius: 50,
          backgroundColor: MyColors.primaryColor,
          child: const Icon(Icons.add_a_photo, color: Colors.white, size: 50),
        ),
      ),
    );
  }

  Widget _imagePreview() {
    return Wrap(
      spacing: 10,
      children: _images.map((image) {
        return Stack(
          children: [
            Image.file(image, width: 100, height: 100, fit: BoxFit.cover),
            Positioned(
              top: 0,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.red),
                onPressed: () {
                  setState(() {
                    _images.remove(image);
                  });
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buttonCrearAlojamiento() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
      child: ElevatedButton(
        onPressed: _crearAlojamiento,
        child: const Text('Crear Alojamiento'),
        style: ElevatedButton.styleFrom(
          backgroundColor: MyColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }

  Future<void> _selectImages() async {
    final List<XFile>? pickedImages = await _picker.pickMultiImage();
    if (pickedImages != null) {
      setState(() {
        _images = pickedImages.map((xFile) => File(xFile.path)).toList();
      });
    }
  }

  Future<void> _crearAlojamiento() async {
    String nombre = _nombreAlojamientoController.text.trim();
    String descripcion = _descripcionController.text.trim();
    String direccion = _direccionController.text.trim();
    String precio = _precioController.text.trim();
    //String categoria = _categoriaController.text.trim();

    if (nombre.isEmpty) {
      MySnackbar.show(context, 'El nombre del alojamiento es obligatorio.', MyColors.validationColor);
      return;
    }

    if (descripcion.isEmpty) {
      MySnackbar.show(context, 'La descripción es obligatoria.', MyColors.validationColor);
      return;
    }

    if (direccion.isEmpty) {
      MySnackbar.show(context, 'La dirección es obligatoria.', MyColors.validationColor);
      return;
    }

    if (precio.isEmpty || double.tryParse(precio) == null || double.parse(precio) <= 0) {
      MySnackbar.show(context, 'El precio debe ser un número válido mayor a 0.', MyColors.validationColor);
      return;
    }

    if (_selectedCategoriaId == null) {
      MySnackbar.show(context, 'Debe seleccionar una categoría.', MyColors.validationColor);
      return;
    }

    if (_selectedServiceIds.isEmpty) {
      MySnackbar.show(context, 'Debe seleccionar al menos un servicio.', MyColors.validationColor);
      return;
    }

    if (_images.isEmpty) {
      MySnackbar.show(context, 'Debe incluir al menos una imagen.', MyColors.validationColor);
      return;
    }


    double precioValue = double.tryParse(precio) ?? 0.0;

    ProgressDialog progressDialog = ProgressDialog(context: context);
    progressDialog.show(max: 100, msg: 'Creando alojamiento...');

    ResponseApi response = await _provider.createAlojamiento(
      //idUser: "1", // Cambia esto según el usuario autenticado
      direccion: direccion,
      neighborhood: "Barrio",
      lat: 0.0,
      lng: 0.0,
      placeId: "place123",
      pais: "Peru",
      estado: "Activo",
      ciudad: "Ciudad de México",
      codigoPostal: "01000",
      idCategoria: _selectedCategoriaId!, // ID de categoría seleccionada
      nombreAlojamiento: nombre,
      descripcion: descripcion,
      precio: precioValue,
      images: _images,
      serviceIds: _selectedServiceIds, // Enviar servicios seleccionados

    );

    progressDialog.close();

    if (response.success) {
      MySnackbar.show(context, 'Alojamiento creado correctamente.', MyColors.successColor);
      Navigator.pop(context);
    } else {
      MySnackbar.show(context, 'Error: ${response.message}', MyColors.errorColor);
    }
  }
}
