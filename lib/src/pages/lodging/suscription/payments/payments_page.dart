import 'package:flutter/material.dart';
import 'payments_controller.dart';

class PaymentsPage extends StatefulWidget {
  const PaymentsPage({Key? key}) : super(key: key);

  @override
  _PaymentsPageState createState() => _PaymentsPageState();
}

class _PaymentsPageState extends State<PaymentsPage> {
  final PaymentsPageController _con = PaymentsPageController();
  String? selectedPlan;
  String? subscriptionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    selectedPlan ??= args?['selectedPlan'] as String?;
    subscriptionId ??= args?['subscriptionId'] as String?;

    _con.init(context, refresh, selectedPlan, subscriptionId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pagos'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan: ${_con.selectedPlan ?? 'No plan selected'}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('Método de Pago:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _con.selectedPaymentMethod,
              items: ['Tarjeta de Crédito', 'PayPal'].map((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) => _con.onPaymentMethodChanged(value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Monto ingresado'),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                _con.userEnteredAmount = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _con.processPayment,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              child: const Text('Realizar Pago'),
            ),
          ],
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
