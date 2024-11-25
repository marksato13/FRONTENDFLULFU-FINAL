import 'package:flutter/material.dart';
import 'package:fluflu/src/models/alojamiento.dart';
import 'package:fluflu/src/utils/my_colors.dart';

class ClientAlojamientoDetailPage extends StatefulWidget {
  final Alojamiento alojamiento;

  const ClientAlojamientoDetailPage({Key? key, required this.alojamiento}) : super(key: key);

  @override
  _ClientAlojamientoDetailPageState createState() => _ClientAlojamientoDetailPageState();
}

class _ClientAlojamientoDetailPageState extends State<ClientAlojamientoDetailPage> {
  String? selectedServiceId;
  String? selectedServiceDescription;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.alojamiento.nombre, style: const TextStyle(fontSize: 24)),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(height: 20),
            _buildCategoryList(),
            if (selectedServiceDescription != null) _buildServiceDescription(),
            const SizedBox(height: 20),
            _buildDetails(),
            const SizedBox(height: 20),
            _buildContactButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: widget.alojamiento.image1.isNotEmpty
          ? Image.network(
        widget.alojamiento.image1,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      )
          : Image.asset(
        'assets/img/no-image.png',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildCategoryList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Wrap(
        spacing: 8.0,
        children: widget.alojamiento.services.map((service) {
          bool isSelected = selectedServiceId == service.id;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedServiceId = service.id;
                selectedServiceDescription = service.descripcion;
              });
            },
            child: Chip(
              label: Text(
                service.nombre,
                style: const TextStyle(fontSize: 16),
              ),
              backgroundColor: isSelected
                  ? MyColors.primaryColor.withOpacity(0.8)
                  : MyColors.primaryColor.withOpacity(0.1),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildServiceDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        selectedServiceDescription!,
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }

  Widget _buildDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.alojamiento.nombre, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        Row(
          children: [
            const Icon(Icons.location_on, color: MyColors.primaryColor),
            const SizedBox(width: 5),
            Expanded(
              child: Text(widget.alojamiento.direccion, style: const TextStyle(fontSize: 16, color: Colors.blueGrey)),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text('S/ ${widget.alojamiento.precio}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: MyColors.primaryColor)),
        const SizedBox(height: 10),
        Text(widget.alojamiento.descripcion, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(height: 20),
        Row(
          children: [
            _iconInfo(Icons.straighten, '6×7 mtrs'),
            _iconInfo(Icons.bathtub_outlined, '1 baño'),
            _iconInfo(Icons.king_bed_outlined, 'Amoblado'),
          ],
        ),
      ],
    );
  }

  Widget _iconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: MyColors.primaryColor, size: 20),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 16, color: Colors.grey)),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildContactButton() {
    return ElevatedButton(
      onPressed: () {
        // Acción de contacto
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
        backgroundColor: MyColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
      ),
      child: const Text('Contactar', style: TextStyle(fontSize: 18)),
    );
  }
}

