import 'dart:convert';

import '../../../shared/domain/entities/ad_entity_id.dart';

Shipment shipmentFromMap(String str) => Shipment.fromMap(json.decode(str));

String shipmentToMap(Shipment data) => json.encode(data.toMap());

class Shipment {
    int? id;
    String? uid;
    String? description;
    AdEntityId movementType;
    DateTime movementDate;
    bool? processed;
    AdEntityId adClientId;
    AdEntityId adOrgId;
    bool? isActive;
    DateTime created;
    AdEntityId createdBy;
    DateTime updated;
    AdEntityId updatedBy;
    bool? isSoTrx;
    String? documentNo;
    AdEntityId cDocTypeId;
    bool? isPrinted;
    DateTime dateAcct;
    AdEntityId cBPartnerId;
    AdEntityId cBPartnerLocationId;
    AdEntityId mWarehouseId;
    AdEntityId deliveryRule;
    AdEntityId freightCostRule;
    int? freightAmt;
    AdEntityId deliveryViaRule;
    int? chargeAmt;
    AdEntityId priorityRule;
    AdEntityId cOrderId;
    DateTime dateOrdered;
    AdEntityId docStatus;
    bool? sendEMail;
    AdEntityId salesRepId;
    int? noPackages;
    bool? isInTransit;
    bool? isApproved;
    bool? isInDispute;
    int? volume;
    int? weight;
    bool? isDropShip;
    double? processedOn;
    bool? isAlternateReturnAddress;
    String? modelName;

    Shipment({
        this.id,
        this.uid,
        this.description,
        required this.movementType,
        required this.movementDate,
        this.processed,
        required this.adClientId,
        required this.adOrgId,
        this.isActive,
        required this.created,
        required this.createdBy,
        required this.updated,
        required this.updatedBy,
        this.isSoTrx,
        this.documentNo,
        required this.cDocTypeId,
        this.isPrinted,
        required this.dateAcct,
        required this.cBPartnerId,
        required this.cBPartnerLocationId,
        required this.mWarehouseId,
        required this.deliveryRule,
        required this.freightCostRule,
        this.freightAmt,
        required this.deliveryViaRule,
        this.chargeAmt,
        required this.priorityRule,
        required this.cOrderId,
        required this.dateOrdered,
        required this.docStatus,
        this.sendEMail,
        required this.salesRepId,
        this.noPackages,
        this.isInTransit,
        this.isApproved,
        this.isInDispute,
        this.volume,
        this.weight,
        this.isDropShip,
        this.processedOn,
        this.isAlternateReturnAddress,
        this.modelName,
    });

    factory Shipment.fromMap(Map<String, dynamic> json) => Shipment(
        id: json["id"],
        uid: json["uid"],
        description: json["Description"],
        movementType: AdEntityId.fromMap(json["MovementType"]),
        movementDate: DateTime.parse(json["MovementDate"]),
        processed: json["Processed"],
        adClientId: AdEntityId.fromMap(json["AD_Client_ID"]),
        adOrgId: AdEntityId.fromMap(json["AD_Org_ID"]),
        isActive: json["IsActive"],
        created: DateTime.parse(json["Created"]),
        createdBy: AdEntityId.fromMap(json["CreatedBy"]),
        updated: DateTime.parse(json["Updated"]),
        updatedBy: AdEntityId.fromMap(json["UpdatedBy"]),
        isSoTrx: json["IsSOTrx"],
        documentNo: json["DocumentNo"],
        cDocTypeId: AdEntityId.fromMap(json["C_DocType_ID"]),
        isPrinted: json["IsPrinted"],
        dateAcct: DateTime.parse(json["DateAcct"]),
        cBPartnerId: AdEntityId.fromMap(json["C_BPartner_ID"]),
        cBPartnerLocationId: AdEntityId.fromMap(json["C_BPartner_Location_ID"]),
        mWarehouseId: AdEntityId.fromMap(json["M_Warehouse_ID"]),
        deliveryRule: AdEntityId.fromMap(json["AdEntityId"]),
        freightCostRule: AdEntityId.fromMap(json["FreightCostRule"]),
        freightAmt: json["FreightAmt"],
        deliveryViaRule: AdEntityId.fromMap(json["DeliveryViaRule"]),
        chargeAmt: json["ChargeAmt"],
        priorityRule: AdEntityId.fromMap(json["PriorityRule"]),
        cOrderId: AdEntityId.fromMap(json["C_Order_ID"]),
        dateOrdered: DateTime.parse(json["DateOrdered"]),
        docStatus: AdEntityId.fromMap(json["DocStatus"]),
        sendEMail: json["SendEMail"],
        salesRepId: AdEntityId.fromMap(json["SalesRep_ID"]),
        noPackages: json["NoPackages"],
        isInTransit: json["IsInTransit"],
        isApproved: json["IsApproved"],
        isInDispute: json["IsInDispute"],
        volume: json["Volume"],
        weight: json["Weight"],
        isDropShip: json["IsDropShip"],
        processedOn: json["ProcessedOn"].toDouble(),
        isAlternateReturnAddress: json["IsAlternateReturnAddress"],
        modelName: json["model-name"],
    );

    Map<String, dynamic> toMap() => {
        "id": id,
        "uid": uid,
        "Description": description,
        "MovementType": movementType.toMap(),
        "MovementDate": "${movementDate.year.toString().padLeft(4, '0')}-${movementDate.month.toString().padLeft(2, '0')}-${movementDate.day.toString().padLeft(2, '0')}",
        "Processed": processed,
        "AD_Client_ID": adClientId.toMap(),
        "AD_Org_ID": adOrgId.toMap(),
        "IsActive": isActive,
        "Created": created.toIso8601String(),
        "CreatedBy": createdBy.toMap(),
        "Updated": updated.toIso8601String(),
        "UpdatedBy": updatedBy.toMap(),
        "IsSOTrx": isSoTrx,
        "DocumentNo": documentNo,
        "C_DocType_ID": cDocTypeId.toMap(),
        "IsPrinted": isPrinted,
        "DateAcct": "${dateAcct.year.toString().padLeft(4, '0')}-${dateAcct.month.toString().padLeft(2, '0')}-${dateAcct.day.toString().padLeft(2, '0')}",
        "C_BPartner_ID": cBPartnerId.toMap(),
        "C_BPartner_Location_ID": cBPartnerLocationId.toMap(),
        "M_Warehouse_ID": mWarehouseId.toMap(),
        "AdEntityId": deliveryRule.toMap(),
        "FreightCostRule": freightCostRule.toMap(),
        "FreightAmt": freightAmt,
        "DeliveryViaRule": deliveryViaRule.toMap(),
        "ChargeAmt": chargeAmt,
        "PriorityRule": priorityRule.toMap(),
        "C_Order_ID": cOrderId.toMap(),
        "DateOrdered": "${dateOrdered.year.toString().padLeft(4, '0')}-${dateOrdered.month.toString().padLeft(2, '0')}-${dateOrdered.day.toString().padLeft(2, '0')}",
        "DocStatus": docStatus.toMap(),
        "SendEMail": sendEMail,
        "SalesRep_ID": salesRepId.toMap(),
        "NoPackages": noPackages,
        "IsInTransit": isInTransit,
        "IsApproved": isApproved,
        "IsInDispute": isInDispute,
        "Volume": volume,
        "Weight": weight,
        "IsDropShip": isDropShip,
        "ProcessedOn": processedOn,
        "IsAlternateReturnAddress": isAlternateReturnAddress,
        "model-name": modelName,
    };
}