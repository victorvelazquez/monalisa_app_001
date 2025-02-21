import 'package:monalisa_app_001/features/shared/domain/entities/ad_entity_id.dart';

class LineConfirm {
  int? id;
  int? targetQty;
  int? confirmedQty;
  AdEntityId? mInOutLineId;
  double? differenceQty;
  double? scrappedQty;

  LineConfirm({
    this.id,
    this.targetQty,
    this.confirmedQty,
    this.mInOutLineId,
    this.differenceQty,
    this.scrappedQty,
  });

  factory LineConfirm.fromJson(Map<String, dynamic> json) => LineConfirm(
        id: json["id"],
        targetQty: json["TargetQty"],
        confirmedQty: json["ConfirmedQty"],
        mInOutLineId: AdEntityId.fromJson(json["M_InOutLine_ID"] ?? {}),
        differenceQty: json["DifferenceQty"],
        scrappedQty: json["ScrappedQty"],

      );

  LineConfirm copyWith({
    int? id,
    int? targetQty,
    int? confirmedQty,
    AdEntityId? mInOutLineId,
    double? differenceQty,
    double? scrappedQty,
  }) {
    return LineConfirm(
      id: id ?? this.id,
      targetQty: targetQty ?? this.targetQty,
      confirmedQty: confirmedQty ?? this.confirmedQty,
      mInOutLineId: mInOutLineId ?? this.mInOutLineId,
      differenceQty: differenceQty ?? this.differenceQty,
      scrappedQty: scrappedQty ?? this.scrappedQty,
    );
  }
}
