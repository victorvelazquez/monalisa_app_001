import 'package:monalisa_app_001/features/shared/domain/entities/ad_entity_id.dart';

class Line {
  int? id;
  int? line;
  double? movementQty;
  double? confirmedQty;
  double? pickedQty;
  double? scrappedQty;
  double? targetQty;
  AdEntityId? mProductId;
  String? upc;
  String? sku;
  String? productName;
  String? verifiedStatus;
  int? scanningQty;
  double? manualQty;
  double? get differenceQty => (targetQty ?? 0.0) - (confirmedQty ?? 0.0);
  int? confirmId;

  Line({
    this.id,
    this.line,
    this.movementQty,
    this.targetQty,
    this.confirmedQty,
    this.pickedQty,
    this.scrappedQty,
    this.mProductId,
    this.upc,
    this.sku,
    this.productName,
    this.verifiedStatus,
    this.scanningQty,
    this.manualQty,
    this.confirmId,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"],
        line: json["Line"],
        movementQty: json["MovementQty"] != null ? (json["MovementQty"] is double ? json["MovementQty"] : double.tryParse(json["MovementQty"].toString()) ?? 0.0) : 0.0,
        mProductId: AdEntityId.fromJson(json["M_Product_ID"] ?? {}),
        upc: json["UPC"],
        sku: json["SKU"],
        productName: json["ProductName"],
      );

  Line copyWith({
    int? id,
    int? line,
    double? movementQty,
    double? targetQty,
    double? confirmedQty,
    double? pickedQty,
    double? scrappedQty,
    AdEntityId? mProductId,
    String? upc,
    String? sku,
    String? productName,
    String? verifiedStatus,
    int? scanningQty,
    double? manualQty,
    int? confirmId,
  }) {
    return Line(
      id: id ?? this.id,
      line: line ?? this.line,
      movementQty: movementQty ?? this.movementQty,
      targetQty: targetQty ?? this.targetQty,
      confirmedQty: confirmedQty ?? this.confirmedQty,
      pickedQty: pickedQty ?? this.pickedQty,
      scrappedQty: scrappedQty ?? this.scrappedQty,
      mProductId: mProductId ?? this.mProductId,
      upc: upc ?? this.upc,
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      scanningQty: scanningQty ?? this.scanningQty,
      manualQty: manualQty ?? this.manualQty,
      confirmId: confirmId ?? this.confirmId,
    );
  }
}
