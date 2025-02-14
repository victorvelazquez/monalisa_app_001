import 'package:monalisa_app_001/features/shared/domain/entities/ad_entity_id.dart';

class Line {
  int? id;
  int? line;
  int? movementQty;
  AdEntityId? mProductId;
  String? upc;
  String? productName;
  String? verifiedStatus;
  int? scanningQty;
  int? manualQty;

  Line({
    this.id,
    this.line,
    this.movementQty,
    this.mProductId,
    this.upc,
    this.productName,
    this.verifiedStatus,
    this.scanningQty,
    this.manualQty,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"],
        line: json["Line"],
        movementQty: json["MovementQty"],
        mProductId: AdEntityId.fromJson(json["M_Product_ID"] ?? {}),
        upc: json["UPC"],
        productName: json["ProductName"],
      );

  Line copyWith({
    int? id,
    int? line,
    int? movementQty,
    AdEntityId? mProductId,
    String? upc,
    String? productName,
    String? verifiedStatus,
    int? scanningQty,
    int? manualQty,
  }) {
    return Line(
      id: id ?? this.id,
      line: line ?? this.line,
      movementQty: movementQty ?? this.movementQty,
      mProductId: mProductId ?? this.mProductId,
      upc: upc ?? this.upc,
      productName: productName ?? this.productName,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      scanningQty: scanningQty ?? this.scanningQty,
      manualQty: manualQty ?? this.manualQty,
    );
  }
}
