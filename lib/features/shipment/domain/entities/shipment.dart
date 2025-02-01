import '../../../shared/domain/entities/ad_entity_id.dart';
import 'line.dart';

class Shipment {
    int? id;
    DateTime movementDate;
    AdEntityId adOrgId;
    bool? isSoTrx;
    String? documentNo;
    AdEntityId cBPartnerId;
    AdEntityId mWarehouseId;
    AdEntityId cOrderId;
    DateTime dateOrdered;
    AdEntityId docStatus;
    List<Line> lines;


    Shipment({
        this.id,
        required this.movementDate,
        required this.adOrgId,
        this.isSoTrx,
        this.documentNo,
        required this.cBPartnerId,
        required this.mWarehouseId,
        required this.cOrderId,
        required this.dateOrdered,
        required this.docStatus,
        this.lines = const [],
    });

    factory Shipment.jsonToEntity(Map<String, dynamic> json) => Shipment(
        id: json["id"],
        movementDate: DateTime.parse(json["MovementDate"]),
        adOrgId: AdEntityId.jsonToEntity(json["AD_Org_ID"]),
        isSoTrx: json["IsSOTrx"],
        documentNo: json["DocumentNo"],
        cBPartnerId: AdEntityId.jsonToEntity(json["C_BPartner_ID"]),
        mWarehouseId: AdEntityId.jsonToEntity(json["M_Warehouse_ID"]),
        cOrderId: AdEntityId.jsonToEntity(json["C_Order_ID"]),
        dateOrdered: DateTime.parse(json["DateOrdered"]),
        docStatus: AdEntityId.jsonToEntity(json["DocStatus"]),
        lines: List<Line>.from(json["m_inoutline"].map((x) => Line.jsonToEntity(x))),
    );

    Shipment copyWith({
      int? id,
      DateTime? movementDate,
      AdEntityId? adOrgId,
      bool? isSoTrx,
      String? documentNo,
      AdEntityId? cBPartnerId,
      AdEntityId? mWarehouseId,
      AdEntityId? cOrderId,
      DateTime? dateOrdered,
      AdEntityId? docStatus,
      List<Line>? lines,
    }) {
      return Shipment(
        id: id ?? this.id,
        movementDate: movementDate ?? this.movementDate,
        adOrgId: adOrgId ?? this.adOrgId,
        isSoTrx: isSoTrx ?? this.isSoTrx,
        documentNo: documentNo ?? this.documentNo,
        cBPartnerId: cBPartnerId ?? this.cBPartnerId,
        mWarehouseId: mWarehouseId ?? this.mWarehouseId,
        cOrderId: cOrderId ?? this.cOrderId,
        dateOrdered: dateOrdered ?? this.dateOrdered,
        docStatus: docStatus ?? this.docStatus,
        lines: lines ?? this.lines,
      );
    }
}