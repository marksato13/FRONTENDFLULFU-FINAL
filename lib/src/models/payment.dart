import 'dart:convert';

Payment paymentFromJson(String str) => Payment.fromJson(json.decode(str));

String paymentToJson(Payment data) => json.encode(data.toJson());

class Payment {
  String idUser;
  String idSubscription;
  double amount;
  String paymentMethod;
  String transactionId;
  String paymentDate;

  Payment({
    required this.idUser,
    required this.idSubscription,
    this.amount = 0.0,
    this.paymentMethod = '',
    this.transactionId = '',
    this.paymentDate = '',
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    idUser: json["id_user"].toString(),
    idSubscription: json["id_subscription"].toString(),
    amount: json["amount"] is double ? json["amount"] : double.tryParse(json["amount"].toString()) ?? 0.0,
    paymentMethod: json["payment_method"] ?? '',
    transactionId: json["transaction_id"] ?? '',
    paymentDate: json["payment_date"] ?? '',
  );

  Map<String, dynamic> toJson() {
    try {
      return {
        "id_user": int.parse(idUser),
        "id_subscription": int.parse(idSubscription),
        "amount": amount,
        "payment_method": paymentMethod,
        "transaction_id": transactionId,
        "payment_date": paymentDate,
      };
    } catch (e) {
      print("Error al convertir los valores a enteros: $e");
      throw Exception("Error al convertir los valores a enteros.");
    }
  }
}
