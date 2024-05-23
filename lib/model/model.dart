import 'dart:convert';

List<Api> apiFromJson(String str) => List<Api>.from(json.decode(str).map((x) => Api.fromJson(x)));

String apiToJson(List<Api> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Api {
  String id;
  String productName;
  String productCode;
  String img;
  String unitPrice;
  String qty;
  String totalPrice;
  DateTime createdDate;

  Api({
    required this.id,
    required this.productName,
    required this.productCode,
    required this.img,
    required this.unitPrice,
    required this.qty,
    required this.totalPrice,
    required this.createdDate,
  });

  factory Api.fromJson(Map<String, dynamic> json) => Api(
    id: json["_id"],
    productName: json["ProductName"],
    productCode: json["ProductCode"],
    img: json["Img"],
    unitPrice: json["UnitPrice"],
    qty: json["Qty"],
    totalPrice: json["TotalPrice"],
    createdDate: DateTime.parse(json["CreatedDate"]),
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "ProductName": productName,
    "ProductCode": productCode,
    "Img": img,
    "UnitPrice": unitPrice,
    "Qty": qty,
    "TotalPrice": totalPrice,
    "CreatedDate": createdDate.toIso8601String(),
  };
}
