import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluflu/src/models/payment.dart';
import 'package:fluflu/src/models/response_api.dart';
import 'package:fluflu/src/provider/payment_provider.dart';
import 'package:fluflu/src/utils/shared_pref.dart';

class PaymentsPageController {
  late BuildContext context;
  late Function refresh;
  String? selectedPlan;
  String selectedPaymentMethod = 'Tarjeta de Crédito';
  String? subscriptionId;
  double userEnteredAmount = 0.0;

  final PaymentProvider _paymentProvider = PaymentProvider();

  void init(BuildContext context, Function refresh, String? selectedPlan, String? subscriptionId) {
    this.context = context;
    this.refresh = refresh;
    this.selectedPlan = selectedPlan;
    this.subscriptionId = subscriptionId;
    refresh();
  }

  void onPaymentMethodChanged(String? method) {
    selectedPaymentMethod = method ?? 'Tarjeta de Crédito';
    refresh();
  }

  Future<void> processPayment() async {
    if (selectedPlan == null || subscriptionId == null) {
      Fluttertoast.showToast(msg: 'No se seleccionó un plan o suscripción.');
      return;
    }

    // Obtén el ID del usuario desde SharedPreferences
    String? userId = await SharedPref().getUserId();
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Error: Usuario no autenticado');
      return;
    }

    // Calcula el monto basado en el plan seleccionado
    double amount = getPlanPrice(selectedPlan!);
    print("Monto calculado para el plan '$selectedPlan': $amount");

    // Verifica que el monto ingresado por el usuario sea válido
    userEnteredAmount = amount;  // Asegúrate de que `userEnteredAmount` coincida con el precio del plan

    Payment payment = Payment(
      idUser: userId,
      idSubscription: subscriptionId!,
      amount: userEnteredAmount, // Monto ingresado por el usuario
      paymentMethod: selectedPaymentMethod,
      transactionId: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      paymentDate: DateTime.now().toIso8601String(),
    );

    // Verifica el contenido de `payment` antes de enviarlo
    print('Datos de pago enviados: ${paymentToJson(payment)}'); // Imprime el JSON para verificar el monto

    ResponseApi response = await _paymentProvider.createPayment(payment);

    if (response.success) {
      Fluttertoast.showToast(
        msg: 'Pago del plan $selectedPlan realizado exitosamente con $selectedPaymentMethod.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
      Navigator.pop(context);
    } else {
      Fluttertoast.showToast(
        msg: 'Error al procesar el pago: ${response.message}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }


  double getPlanPrice(String planId) {
    switch (planId) {
      case '1': // ID del plan Gratuito
        return 0.0;
      case '2': // ID del plan Estándar
        return 9.99;
      case '3': // ID del plan Premium
        return 19.99;
      default:
        print("Advertencia: El plan '$planId' no coincide con ninguna opción conocida. Asignando monto predeterminado 0.0");
        return 0.0;
    }
  }


}
