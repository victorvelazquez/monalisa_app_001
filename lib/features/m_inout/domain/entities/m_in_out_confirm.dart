import '../../../shared/domain/entities/ad_entity_id.dart';
import 'line_confirm.dart';

class MInOutConfirm {
    int? id;
    AdEntityId mInOutId;
    String? documentNo;
    AdEntityId docStatus;
    List<LineConfirm> linesConfirm;


    MInOutConfirm({
        this.id,
        required this.mInOutId,
        this.documentNo,
        required this.docStatus,
        this.linesConfirm = const [],
    });

    factory MInOutConfirm.fromJson(Map<String, dynamic> json) => MInOutConfirm(
        id: json["id"] ?? 0,
        mInOutId: json["M_InOut_ID"] != null ? AdEntityId.fromJson(json["M_InOut_ID"]) : AdEntityId(),
        documentNo: json["DocumentNo"] ?? '',
        docStatus: json["DocStatus"] != null ? AdEntityId.fromJson(json["DocStatus"]) : AdEntityId(),
        linesConfirm: json["m_inoutlineconfirm"] != null ? List<LineConfirm>.from(json["m_inoutlineconfirm"].map((x) => LineConfirm.fromJson(x))) : [],
    );

    MInOutConfirm copyWith({
      int? id,
      AdEntityId? mInOutId,
      String? documentNo,
      AdEntityId? docStatus,
      List<LineConfirm>? linesConfirm,
    }) {
      return MInOutConfirm(
        id: id ?? this.id,
        mInOutId: mInOutId ?? this.mInOutId,
        documentNo: documentNo ?? this.documentNo,
        docStatus: docStatus ?? this.docStatus,
        linesConfirm: linesConfirm ?? this.linesConfirm,
      );
    }
}