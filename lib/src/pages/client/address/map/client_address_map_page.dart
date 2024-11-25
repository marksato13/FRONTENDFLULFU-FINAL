import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
//import 'package:fluflu/src/pages/client/address/list/client_address_list_controller.dart';
import 'package:fluflu/src/pages/client/address/map/client_address_map_controller.dart';
import 'package:fluflu/src/utils/my_colors.dart';
import 'package:fluflu/src/widgets/no_data_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ClientAddressMapPage extends StatefulWidget {
  const ClientAddressMapPage({Key? key}) : super(key: key);

  @override
  _ClientAddressMapPageState createState() => _ClientAddressMapPageState();
}

class _ClientAddressMapPageState extends State<ClientAddressMapPage> {

  ClientAddressMapController _con = new ClientAddressMapController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ubica tu direccion en el mapa'),
      ),
      body: Stack(
        children: [
          _googleMaps(),
          Container(
            alignment: Alignment.center,
            child: _iconMyLocation(),
          ),
          Container(
            margin: EdgeInsets.only(top: 30),
            alignment: Alignment.topCenter,
          ),
          Container(
            alignment: Alignment.bottomCenter,
          )
        ],
      ),
    );
  }

  Widget _iconMyLocation() {
    return Image.asset(
      'assets/img/my_location.png',
      width: 65,
      height: 65,
    );
  }

  Widget _googleMaps() {
    return GoogleMap(
      mapType: MapType.satellite,

      initialCameraPosition: _con.initialPosition,
      onMapCreated: _con.onMapCreated,
      myLocationButtonEnabled: false,
      myLocationEnabled: false,
      onCameraMove: (position) {
        _con.initialPosition = position;
      },
      onCameraIdle: () async {
        await _con.setLocationDraggableInfo();
      },
    );
  }

  void refresh() {
    setState(() {});
  }
}
