import '../../../shared/domain/entities/ad_entity_id.dart';
import 'line.dart';

class MInOut {
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


    MInOut({
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

    factory MInOut.fromJson(Map<String, dynamic> json) => MInOut(
        id: json["id"],
        movementDate: DateTime.parse(json["MovementDate"]),
        adOrgId: AdEntityId.fromJson(json["AD_Org_ID"]),
        isSoTrx: json["IsSOTrx"],
        documentNo: json["DocumentNo"],
        cBPartnerId: AdEntityId.fromJson(json["C_BPartner_ID"]),
        mWarehouseId: AdEntityId.fromJson(json["M_Warehouse_ID"]),
        cOrderId: AdEntityId.fromJson(json["C_Order_ID"]),
        dateOrdered: DateTime.parse(json["DateOrdered"]),
        docStatus: AdEntityId.fromJson(json["DocStatus"]),
        lines: List<Line>.from(json["m_inoutline"].map((x) => Line.fromJson(x))),
    );

    MInOut copyWith({
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
      return MInOut(
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