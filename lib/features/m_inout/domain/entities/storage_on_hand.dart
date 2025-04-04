import '../../../shared/domain/entities/ad_entity_id.dart';

class StorageOnHand {
  String? uid;
  AdEntityId? locator;
  double? qtyOnHand;
  StorageOnHand({
    this.uid,
    this.locator,
    this.qtyOnHand,
  });

  factory StorageOnHand.fromJson(Map<String, dynamic> json) => StorageOnHand(
        uid: json["uid"],
        locator: json["M_Locator_ID"] != null ? AdEntityId.fromJson(json["M_Locator_ID"]) : null,
        qtyOnHand: json["QtyOnHand"]?.toDouble() ?? 0.0,
      );

  StorageOnHand copyWith({
    String? uid,
    AdEntityId? locator,
    double? qtyOnHand,
  }) {
    return StorageOnHand(
      uid: uid ?? this.uid,
      locator: locator ?? this.locator,
      qtyOnHand: qtyOnHand ?? this.qtyOnHand,
    );
  }
}
