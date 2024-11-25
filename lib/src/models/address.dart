class Address {
  String id;
  String idUser;
  String direccion;
  String neighborhood;
  double lat;
  double lng;
  String placeId;
  String pais;
  String estado;
  String ciudad;
  String codigoPostal;

  Address({
    this.id = '',
    this.idUser = '',
    this.direccion = '',
    this.neighborhood = '',
    this.lat = 0.0,
    this.lng = 0.0,
    this.placeId = '',
    this.pais = '',
    this.estado = '',
    this.ciudad = '',
    this.codigoPostal = '',
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    try {
      return Address(
        id: json['id']?.toString() ?? '',
        idUser: json['id_user']?.toString() ?? '',
        direccion: json['direccion'] ?? '',
        neighborhood: json['neighborhood'] ?? '',
        lat: double.tryParse(json['lat']?.toString() ?? '0.0') ?? 0.0,
        lng: double.tryParse(json['lng']?.toString() ?? '0.0') ?? 0.0,
        placeId: json['place_id'] ?? '',
        pais: json['pais'] ?? '',
        estado: json['estado'] ?? '',
        ciudad: json['ciudad'] ?? '',
        codigoPostal: json['codigo_postal'] ?? '',
      );
    } catch (e) {
      throw FormatException('Error al parsear Address: $e');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'id_user': idUser,
      'direccion': direccion,
      'neighborhood': neighborhood,
      'lat': lat,
      'lng': lng,
      'place_id': placeId,
      'pais': pais,
      'estado': estado,
      'ciudad': ciudad,
      'codigo_postal': codigoPostal,
    };
  }
}
