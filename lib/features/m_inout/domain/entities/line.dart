import 'package:monalisa_app_001/features/shared/domain/entities/ad_entity_id.dart';

class Line {
  int? id;
  int? line;
  int? movementQty;
  AdEntityId? mProductId;
  String? upc;
  String? sku;
  String? productName;
  String? verifiedStatus;
  int? scanningQty;
  int? manualQty;
  int? confirmId;
  int? confirmTargetQty;
  int? confirmConfirmedQty;
  double? confirmDifferenceQty;
  double? confirmScrappedQty;

  Line({
    this.id,
    this.line,
    this.movementQty,
    this.mProductId,
    this.upc,
    this.sku,
    this.productName,
    this.verifiedStatus,
    this.scanningQty,
    this.manualQty,
    this.confirmId,
    this.confirmTargetQty,
    this.confirmConfirmedQty,
    this.confirmDifferenceQty,
    this.confirmScrappedQty,
  });

  factory Line.fromJson(Map<String, dynamic> json) => Line(
        id: json["id"],
        line: json["Line"],
        movementQty: json["MovementQty"],
        mProductId: AdEntityId.fromJson(json["M_Product_ID"] ?? {}),
        upc: json["UPC"],
        sku: json["SKU"],
        productName: json["ProductName"],
      );

  Line copyWith({
    int? id,
    int? line,
    int? movementQty,
    AdEntityId? mProductId,
    String? upc,
    String? sku,
    String? productName,
    String? verifiedStatus,
    int? scanningQty,
    int? manualQty,
    int? confirmId,
    int? confirmTargetQty,
    int? confirmConfirmedQty,
    double? confirmDifferenceQty,
    double? confirmScrappedQty,
  }) {
    return Line(
      id: id ?? this.id,
      line: line ?? this.line,
      movementQty: movementQty ?? this.movementQty,
      mProductId: mProductId ?? this.mProductId,
      upc: upc ?? this.upc,
      sku: sku ?? this.sku,
      productName: productName ?? this.productName,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      scanningQty: scanningQty ?? this.scanningQty,
      manualQty: manualQty ?? this.manualQty,
      confirmId: confirmId ?? this.confirmId,
      confirmTargetQty: confirmTargetQty ?? this.confirmTargetQty,
      confirmConfirmedQty: confirmConfirmedQty ?? this.confirmConfirmedQty,
      confirmDifferenceQty: confirmDifferenceQty ?? this.confirmDifferenceQty,
      confirmScrappedQty: confirmScrappedQty ?? this.confirmScrappedQty,
    );
  }
}
