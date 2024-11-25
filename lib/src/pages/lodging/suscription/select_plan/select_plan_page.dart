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

  Future<void> createSubscriptionAndRedirect(String planId) async {
    if (userId == null) {
      Fluttertoast.showToast(msg: 'Error: Usuario no autenticado');
      return;
    }

    Subscription subscription = Subscription(
      idUser: userId!,
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

class SelectPlanPage extends StatefulWidget {
  const SelectPlanPage({Key? key}) : super(key: key);

  @override
  _SelectPlanPageState createState() => _SelectPlanPageState();
}

class _SelectPlanPageState extends State<SelectPlanPage> {
  final SelectPlanPageController _con = SelectPlanPageController();

  @override
  void initState() {
    super.initState();
    _con.init(context, refresh);
  }

  void refresh() {
    setState(() {});
  }

  void _showConfirmationDialog(String planId, String planName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Estas seleccionando el plan $planName"),
        content: const Text("¿Deseas continuar?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _con.createSubscriptionAndRedirect(planId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
            child: const Text("Continuar"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selecciona un Plan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlanCard('1', 'Gratuito', 'Acceso Básico', 'S/ 0.00', '1', Colors.blueAccent, Colors.lightBlueAccent),
            const SizedBox(height: 10),
            _buildPlanCard('2', 'Estándar', 'Acceso Estándar', 'S/ 9.99', '2', Colors.deepPurple, Colors.deepPurpleAccent),
            const SizedBox(height: 10),
            _buildPlanCard('3', 'Premium', 'Acceso RHLM', 'S/ 19.99', '3+', Colors.orangeAccent, Colors.deepOrangeAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanCard(
      String planId, String title, String access, String price, String alojamientos, Color startColor, Color endColor) {
    return GestureDetector(
      onTap: () => _showConfirmationDialog(planId, title),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(4, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan $title',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              access,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Alojamientos Permitidos: $alojamientos',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                Text(
                  'Precio: $price',
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Center(
              child: ElevatedButton(
                onPressed: () => _showConfirmationDialog(planId, title),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white.withOpacity(0.8),
                  foregroundColor: Colors.black,
                ),
                child: const Text("Seleccionar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
