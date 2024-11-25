import 'dart:convert';

Subscription subscriptionFromJson(String str) => Subscription.fromJson(json.decode(str));

String subscriptionToJson(Subscription data) => json.encode(data.toJson());

class Subscription {
  String id;
  String idUser; // Representado como String pero convertido a int en el backend
  String idPlan;
  String startDate;
  String endDate;
  String status;

  Subscription({
    this.id = '',
    required this.idUser,
    required this.idPlan,
    this.startDate = '',
    this.endDate = '',
    this.status = 'pending',
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    id: json["id"].toString(),
    idUser: json["id_user"].toString(),
    idPlan: json["id_plan"].toString(),
    startDate: json["start_date"] ?? '',
    endDate: json["end_date"] ?? '',
    status: json["status"] ?? 'pending',
  );

  Map<String, dynamic> toJson() => {
    "id_user": idUser, // Pasamos como String, será convertido a int en el backend
    "id_plan": idPlan,
    "start_date": startDate,
    "end_date": endDate,
    "status": status,
  };
}
