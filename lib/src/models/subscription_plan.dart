import 'dart:convert';

SubscriptionPlan subscriptionPlanFromJson(String str) => SubscriptionPlan.fromJson(json.decode(str));

String subscriptionPlanToJson(SubscriptionPlan data) => json.encode(data.toJson());

class SubscriptionPlan {
  String id;
  String name;
  double price;
  int durationInMonths;

  SubscriptionPlan({
    this.id = '',
    this.name = '',
    this.price = 0.0,
    this.durationInMonths = 0,
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    id: json["id"].toString(),
    name: json["name"],
    price: double.parse(json["price"].toString()),
    durationInMonths: json["duration_in_months"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "price": price,
    "duration_in_months": durationInMonths,
  };
}
