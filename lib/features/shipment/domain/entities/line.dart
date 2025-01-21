import 'dart:convert';

import 'ad_entity_id.dart';

Line lineFromMap(String str) => Line.fromMap(json.decode(str));

String lineToMap(Line data) => json.encode(data.toMap());

class Line {
    int? id;
    String? uid;
    AdEntityId adClientId;
    AdEntityId adOrgId;
    bool? isActive;
    DateTime created;
    AdEntityId createdBy;
    DateTime updated;
    AdEntityId updatedBy;
    AdEntityId mLocatorId;
    AdEntityId mInOutId;
    AdEntityId mProductId;
    int? movementQty;
    int? line;
    AdEntityId cOrderLineId;
    AdEntityId cUomId;
    bool? isInvoiced;
    AdEntityId mAttributeSetInstanceId;
    bool? isDescription;
    int? confirmedQty;
    int? pickedQty;
    int? scrappedQty;
    int? targetQty;
    int? refInOutLineId;
    bool? processed;
    int? qtyEntered;
    bool? isAutoProduce;
    String? upc;
    String? productName;
    String? sku;
    String? modelName;

    Line({
        this.id,
        this.uid,
        required this.adClientId,
        required this.adOrgId,
        this.isActive,
        required this.created,
        required this.createdBy,
        required this.updated,
        required this.updatedBy,
        required this.mLocatorId,
        required this.mInOutId,
        required this.mProductId,
        this.movementQty,
        this.line,
        required this.cOrderLineId,
        required this.cUomId,
        this.isInvoiced,
        required this.mAttributeSetInstanceId,
        this.isDescription,
        this.confirmedQty,
        this.pickedQty,
        this.scrappedQty,
        this.targetQty,
        this.refInOutLineId,
        this.processed,
        this.qtyEntered,
        this.isAutoProduce,
        this.upc,
        this.productName,
        this.sku,
        this.modelName,
    });

    factory Line.fromMap(Map<String, dynamic> json) => Line(
        id: json["id"],
        uid: json["uid"],
        adClientId: AdEntityId.fromMap(json["AD_Client_ID"]),
        adOrgId: AdEntityId.fromMap(json["AD_Org_ID"]),
        isActive: json["IsActive"],
        created: DateTime.parse(json["Created"]),
        createdBy: AdEntityId.fromMap(json["CreatedBy"]),
        updated: DateTime.parse(json["Updated"]),
        updatedBy: AdEntityId.fromMap(json["UpdatedBy"]),
        mLocatorId: AdEntityId.fromMap(json["M_Locator_ID"]),
        mInOutId: AdEntityId.fromMap(json["M_InOut_ID"]),
        mProductId: AdEntityId.fromMap(json["M_Product_ID"]),
        movementQty: json["MovementQty"],
        line: json["Line"],
        cOrderLineId: AdEntityId.fromMap(json["C_OrderLine_ID"]),
        cUomId: AdEntityId.fromMap(json["C_UOM_ID"]),
        isInvoiced: json["IsInvoiced"],
        mAttributeSetInstanceId: AdEntityId.fromMap(json["M_AttributeSetInstance_ID"]),
        isDescription: json["IsDescription"],
        confirmedQty: json["ConfirmedQty"],
        pickedQty: json["PickedQty"],
        scrappedQty: json["ScrappedQty"],
        targetQty: json["TargetQty"],
        refInOutLineId: json["Ref_InOutLine_ID"],
        processed: json["Processed"],
        qtyEntered: json["QtyEntered"],
        isAutoProduce: json["IsAutoProduce"],
        upc: json["UPC"],
        productName: json["ProductName"],
        sku: json["SKU"],
        modelName: json["model-name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "uid": uid,
        "AD_Client_ID": adClientId.toMap(),
        "AD_Org_ID": adOrgId.toMap(),
        "IsActive": isActive,
        "Created": created.toIso8601String(),
        "CreatedBy": createdBy.toMap(),
        "Updated": updated.toIso8601String(),
        "UpdatedBy": updatedBy.toMap(),
        "M_Locator_ID": mLocatorId.toMap(),
        "M_InOut_ID": mInOutId.toMap(),
        "M_Product_ID": mProductId.toMap(),
        "MovementQty": movementQty,
        "Line": line,
        "C_OrderLine_ID": cOrderLineId.toMap(),
        "C_UOM_ID": cUomId.toMap(),
        "IsInvoiced": isInvoiced,
        "M_AttributeSetInstance_ID": mAttributeSetInstanceId.toMap(),
        "IsDescription": isDescription,
        "ConfirmedQty": confirmedQty,
        "PickedQty": pickedQty,
        "ScrappedQty": scrappedQty,
        "TargetQty": targetQty,
        "Ref_InOutLine_ID": refInOutLineId,
        "Processed": processed,
        "QtyEntered": qtyEntered,
        "IsAutoProduce": isAutoProduce,
        "UPC": upc,
        "ProductName": productName,
        "SKU": sku,
        "model-name": modelName,
    };
}