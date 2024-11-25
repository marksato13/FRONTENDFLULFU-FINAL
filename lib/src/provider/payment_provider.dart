import 'dart:convert';
import 'package:fluflu/src/models/payment.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/api/environment.dart';
import 'package:http/http.dart' as http;

class PaymentProvider {
  String _url = Environment.API_FLUFLU;
  String _api = '/api/payments';

  Future<ResponseApi> createPayment(Payment payment) async {
    try {
      Uri url = Uri.http(_url, '$_api/create');
      String bodyParams = json.encode(payment.toJson());

      print("Body Params enviado al backend: $bodyParams");  // Esto debería mostrar el amount correcto

      final res = await http.post(
        url,
        headers: {'Content-type': 'application/json'},
        body: bodyParams,
      );

      print("Respuesta del backend: ${res.body}");

      final data = json.decode(res.body);
      return ResponseApi.fromJson(data);
    } catch (e) {
      print('Error al crear el pago: $e');
      return ResponseApi(success: false, message: 'Error al crear el pago', error: 'Error');
    }
  }

}
