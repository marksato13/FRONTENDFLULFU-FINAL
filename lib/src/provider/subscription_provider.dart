import 'dart:convert';
import 'package:fluflu/src/models/subscription.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:http/http.dart' as http;

class SubscriptionProvider {
  String _url = Environment.API_FLUFLU;
  String _api = '/api/subscriptions';

  Future<ResponseApi> createSubscription(Subscription subscription) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');

      // Convertimos `id_user` e `id_plan` a enteros antes de enviarlos
      final Map<String, dynamic> bodyParams = {
        "id_user": int.tryParse(subscription.idUser) ?? 0, // int.parse con manejo de error
        "id_plan": int.tryParse(subscription.idPlan) ?? 0  // int.parse con manejo de error
      };

      // Log para verificar el contenido que se está enviando al backend
      print("Enviando cuerpo de la solicitud: $bodyParams");

      final res = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: json.encode(bodyParams),
      );

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);
    } catch (e) {
      print('Error al crear suscripción: $e');
      return ResponseApi(
        success: false,
        message: 'Error al crear suscripción: $e',
        error: 'Error',
      );
    }
  }
}
