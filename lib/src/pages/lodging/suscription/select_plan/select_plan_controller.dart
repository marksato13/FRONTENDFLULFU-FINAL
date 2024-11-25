import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:fluflu/src/models/subscription.dart';
import 'package:fluflu/src/provider/subscription_provider.dart';
import 'package:fluflu/src/utils/shared_pref.dart';

class SelectPlanPageController {
  late BuildContext context;
  late Function refresh;
  String? userId;

  Future<void> init(BuildContext context, Function refresh) async {
    this.context = context;
    this.refresh = refresh;

    // Obtiene el ID del usuario desde SharedPreferences
    userId = await SharedPref().getUserId();

    if (userId == null || userId!.isEmpty) {
      Fluttertoast.showToast(msg: 'Error: Usuario no autenticado');
      Navigator.pop(context); // Regresa si el usuario no está autenticado
    } else {
      refresh();
    }
  }

  Future<void> createSubscription(String planId) async {
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Error: Usuario no autenticado');
      return;
    }

    Subscription subscription = Subscription(
      idUser: userId!,  // Usa el `userId` autenticado
      idPlan: planId,
    );

    final response = await SubscriptionProvider().createSubscription(subscription);
    if (response.success) {
      String subscriptionId = response.data;
      Navigator.pushNamed(context, '/payments', arguments: {
        'selectedPlan': planId,
        'subscriptionId': subscriptionId,
      });
    } else {
      Fluttertoast.showToast(msg: 'Error al crear suscripción: ${response.message}');
    }
  }
}
