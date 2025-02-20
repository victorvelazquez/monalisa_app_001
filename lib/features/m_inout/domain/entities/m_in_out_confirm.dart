import '../../../shared/domain/entities/ad_entity_id.dart';

class MInOutConfirm {
    int? id;
    AdEntityId mInOutId;
    String? documentNo;
    AdEntityId docStatus;


    MInOutConfirm({
        this.id,
        required this.mInOutId,
        this.documentNo,
        required this.docStatus,
    });

    factory MInOutConfirm.fromJson(Map<String, dynamic> json) => MInOutConfirm(
        id: json["id"] ?? 0,
        mInOutId: json["M_InOut_ID"] != null ? AdEntityId.fromJson(json["M_InOut_ID"]) : AdEntityId(),
        documentNo: json["DocumentNo"] ?? '',
        docStatus: json["DocStatus"] != null ? AdEntityId.fromJson(json["DocStatus"]) : AdEntityId(),
    );

    MInOutConfirm copyWith({
      int? id,
      AdEntityId? mInOutId,
      String? documentNo,
      AdEntityId? docStatus,
    }) {
      return MInOutConfirm(
        id: id ?? this.id,
        mInOutId: mInOutId ?? this.mInOutId,
        documentNo: documentNo ?? this.documentNo,
        docStatus: docStatus ?? this.docStatus,
      );
    }
}