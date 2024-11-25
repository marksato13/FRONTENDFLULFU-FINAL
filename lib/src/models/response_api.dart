import 'dart:convert';

/// Convierte un JSON string en un objeto `ResponseApi`
ResponseApi responseApiFromJson(String str) => ResponseApi.fromJson(json.decode(str));

/// Convierte un objeto `ResponseApi` en JSON string
String responseApiToJson(ResponseApi data) => json.encode(data.toJson());

/// Clase para manejar las respuestas del API
class ResponseApi {
  String message; // Mensaje de la respuesta
  String? error; // Detalles del error (opcional)
  bool success; // Indica si la operación fue exitosa
  dynamic data; // Datos de la respuesta (puede ser cualquier cosa)

  ResponseApi({
    required this.message,
    this.error, // Error es opcional
    required this.success,
    this.data, // Data puede ser null o cualquier tipo
  });

  /// Constructor que genera un objeto `ResponseApi` desde JSON
  factory ResponseApi.fromJson(Map<String, dynamic> json) {
    return ResponseApi(
      message: json["message"] ?? '', // Si falta, asigna un string vacío
      error: json["error"], // Error puede ser null
      success: json["success"] ?? false, // Si falta, asume que no fue exitoso
      data: json["data"], // Puede contener cualquier tipo de datos
    );
  }

  /// Convierte un objeto `ResponseApi` a un mapa JSON
  Map<String, dynamic> toJson() => {
    "message": message,
    "error": error,
    "success": success,
    "data": data,
  };
}
