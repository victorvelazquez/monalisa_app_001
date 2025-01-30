import '../../../shared/domain/entities/ad_entity_id.dart';

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
    AdEntityId mProductId;
    int? movementQty;
    int? line;
    AdEntityId cOrderLineId;
    AdEntityId cUomId;
    bool? isInvoiced;
    AdEntityId mAttributeSetInstanceId;
    bool? isDescription;
    double? confirmedQty;
    double? pickedQty;
    double? scrappedQty;
    double? targetQty;
    int? refInOutLineId;
    bool? processed;
    int? qtyEntered;
    bool? isAutoProduce;
    String? upc;
    String? productName;
    String? sku;
    String? modelName;
    String? verifiedStatus;
    int? scanningQty;



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
        this.verifiedStatus,
        this.scanningQty,
    });

    factory Line.jsonToEntity(Map<String, dynamic> json) => Line(
        id: json["id"],
        uid: json["uid"],
        adClientId: AdEntityId.jsonToEntity(json["AD_Client_ID"]),
        adOrgId: AdEntityId.jsonToEntity(json["AD_Org_ID"]),
        isActive: json["IsActive"],
        created: DateTime.parse(json["Created"]),
        createdBy: AdEntityId.jsonToEntity(json["CreatedBy"]),
        updated: DateTime.parse(json["Updated"]),
        updatedBy: AdEntityId.jsonToEntity(json["UpdatedBy"]),
        mLocatorId: AdEntityId.jsonToEntity(json["M_Locator_ID"]),
        mProductId: AdEntityId.jsonToEntity(json["M_Product_ID"]),
        movementQty: json["MovementQty"],
        line: json["Line"],
        cOrderLineId: AdEntityId.jsonToEntity(json["C_OrderLine_ID"]),
        cUomId: AdEntityId.jsonToEntity(json["C_UOM_ID"]),
        isInvoiced: json["IsInvoiced"],
        mAttributeSetInstanceId: AdEntityId.jsonToEntity(json["M_AttributeSetInstance_ID"]),
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

    Line copyWith({
      int? id,
      String? uid,
      AdEntityId? adClientId,
      AdEntityId? adOrgId,
      bool? isActive,
      DateTime? created,
      AdEntityId? createdBy,
      DateTime? updated,
      AdEntityId? updatedBy,
      AdEntityId? mLocatorId,
      AdEntityId? mProductId,
      int? movementQty,
      int? line,
      AdEntityId? cOrderLineId,
      AdEntityId? cUomId,
      bool? isInvoiced,
      AdEntityId? mAttributeSetInstanceId,
      bool? isDescription,
      double? confirmedQty,
      double? pickedQty,
      double? scrappedQty,
      double? targetQty,
      int? refInOutLineId,
      bool? processed,
      int? qtyEntered,
      bool? isAutoProduce,
      String? upc,
      String? productName,
      String? sku,
      String? modelName,
      String? verifiedStatus,
      int? scanningQty,
    }) {
      return Line(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        adClientId: adClientId ?? this.adClientId,
        adOrgId: adOrgId ?? this.adOrgId,
        isActive: isActive ?? this.isActive,
        created: created ?? this.created,
        createdBy: createdBy ?? this.createdBy,
        updated: updated ?? this.updated,
        updatedBy: updatedBy ?? this.updatedBy,
        mLocatorId: mLocatorId ?? this.mLocatorId,
        mProductId: mProductId ?? this.mProductId,
        movementQty: movementQty ?? this.movementQty,
        line: line ?? this.line,
        cOrderLineId: cOrderLineId ?? this.cOrderLineId,
        cUomId: cUomId ?? this.cUomId,
        isInvoiced: isInvoiced ?? this.isInvoiced,
        mAttributeSetInstanceId: mAttributeSetInstanceId ?? this.mAttributeSetInstanceId,
        isDescription: isDescription ?? this.isDescription,
        confirmedQty: confirmedQty ?? this.confirmedQty,
        pickedQty: pickedQty ?? this.pickedQty,
        scrappedQty: scrappedQty ?? this.scrappedQty,
        targetQty: targetQty ?? this.targetQty,
        refInOutLineId: refInOutLineId ?? this.refInOutLineId,
        processed: processed ?? this.processed,
        qtyEntered: qtyEntered ?? this.qtyEntered,
        isAutoProduce: isAutoProduce ?? this.isAutoProduce,
        upc: upc ?? this.upc,
        productName: productName ?? this.productName,
        sku: sku ?? this.sku,
        modelName: modelName ?? this.modelName,
        verifiedStatus: verifiedStatus ?? this.verifiedStatus,
        scanningQty: scanningQty ?? this.scanningQty,
      );
    }
}