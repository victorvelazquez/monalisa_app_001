import '../../../shared/domain/entities/ad_entity_id.dart';
import 'line.dart';

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
    AdEntityId adUserId;
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
    double? volume;
    double? weight;
    bool? isDropShip;
    double? processedOn;
    bool? isAlternateReturnAddress;
    String? moliVehicleType;
    String? drivername;
    String? moliTransportDirection;
    String? moliRucTransportista;
    String? driverid;
    String? moliDistancia;
    String? vehicle;
    String? vehicleid;
    DateTime moliEndTransfer;
    DateTime moliStartTransfer;
    String? moliTransportista;
    String? modelName;
    List<Line> lines;


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
        required this.adUserId,
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
        this.moliVehicleType,
        this.drivername,
        this.moliTransportDirection,
        this.moliRucTransportista,
        this.driverid,
        this.moliDistancia,
        this.vehicle,
        this.vehicleid,
        required this.moliEndTransfer,
        required this.moliStartTransfer,
        this.moliTransportista,
        this.modelName,
        this.lines = const [],
    });

    factory Shipment.jsonToEntity(Map<String, dynamic> json) => Shipment(
        id: json["id"],
        uid: json["uid"],
        description: json["Description"],
        movementType: AdEntityId.jsonToEntity(json["MovementType"]),
        movementDate: DateTime.parse(json["MovementDate"]),
        processed: json["Processed"],
        adClientId: AdEntityId.jsonToEntity(json["AD_Client_ID"]),
        adOrgId: AdEntityId.jsonToEntity(json["AD_Org_ID"]),
        isActive: json["IsActive"],
        created: DateTime.parse(json["Created"]),
        createdBy: AdEntityId.jsonToEntity(json["CreatedBy"]),
        updated: DateTime.parse(json["Updated"]),
        updatedBy: AdEntityId.jsonToEntity(json["UpdatedBy"]),
        isSoTrx: json["IsSOTrx"],
        documentNo: json["DocumentNo"],
        cDocTypeId: AdEntityId.jsonToEntity(json["C_DocType_ID"]),
        isPrinted: json["IsPrinted"],
        dateAcct: DateTime.parse(json["DateAcct"]),
        cBPartnerId: AdEntityId.jsonToEntity(json["C_BPartner_ID"]),
        cBPartnerLocationId: AdEntityId.jsonToEntity(json["C_BPartner_Location_ID"]),
        adUserId: AdEntityId.jsonToEntity(json["AD_User_ID"]),
        mWarehouseId: AdEntityId.jsonToEntity(json["M_Warehouse_ID"]),
        deliveryRule: AdEntityId.jsonToEntity(json["DeliveryRule"]),
        freightCostRule: AdEntityId.jsonToEntity(json["FreightCostRule"]),
        freightAmt: json["FreightAmt"],
        deliveryViaRule: AdEntityId.jsonToEntity(json["DeliveryViaRule"]),
        chargeAmt: json["ChargeAmt"],
        priorityRule: AdEntityId.jsonToEntity(json["PriorityRule"]),
        cOrderId: AdEntityId.jsonToEntity(json["C_Order_ID"]),
        dateOrdered: DateTime.parse(json["DateOrdered"]),
        docStatus: AdEntityId.jsonToEntity(json["DocStatus"]),
        sendEMail: json["SendEMail"],
        salesRepId: AdEntityId.jsonToEntity(json["SalesRep_ID"]),
        noPackages: json["NoPackages"],
        isInTransit: json["IsInTransit"],
        isApproved: json["IsApproved"],
        isInDispute: json["IsInDispute"],
        volume: json["Volume"],
        weight: json["Weight"],
        isDropShip: json["IsDropShip"],
        processedOn: json["ProcessedOn"].toDouble(),
        isAlternateReturnAddress: json["IsAlternateReturnAddress"],
        moliVehicleType: json["MOLI_VehicleType"],
        drivername: json["DRIVERNAME"],
        moliTransportDirection: json["MOLI_TransportDirection"],
        moliRucTransportista: json["MOLI_RucTransportista"],
        driverid: json["DRIVERID"],
        moliDistancia: json["MOLI_Distancia"],
        vehicle: json["VEHICLE"],
        vehicleid: json["VEHICLEID"],
        moliEndTransfer: DateTime.parse(json["MOLI_EndTransfer"]),
        moliStartTransfer: DateTime.parse(json["MOLI_StartTransfer"]),
        moliTransportista: json["MOLI_Transportista"],
        modelName: json["model-name"],
        lines: List<Line>.from(json["m_inoutline"].map((x) => Line.jsonToEntity(x))),
    );

    Shipment copyWith({
      int? id,
      String? uid,
      String? description,
      AdEntityId? movementType,
      DateTime? movementDate,
      bool? processed,
      AdEntityId? adClientId,
      AdEntityId? adOrgId,
      bool? isActive,
      DateTime? created,
      AdEntityId? createdBy,
      DateTime? updated,
      AdEntityId? updatedBy,
      bool? isSoTrx,
      String? documentNo,
      AdEntityId? cDocTypeId,
      bool? isPrinted,
      DateTime? dateAcct,
      AdEntityId? cBPartnerId,
      AdEntityId? cBPartnerLocationId,
      AdEntityId? adUserId,
      AdEntityId? mWarehouseId,
      AdEntityId? deliveryRule,
      AdEntityId? freightCostRule,
      int? freightAmt,
      AdEntityId? deliveryViaRule,
      int? chargeAmt,
      AdEntityId? priorityRule,
      AdEntityId? cOrderId,
      DateTime? dateOrdered,
      AdEntityId? docStatus,
      bool? sendEMail,
      AdEntityId? salesRepId,
      int? noPackages,
      bool? isInTransit,
      bool? isApproved,
      bool? isInDispute,
      double? volume,
      double? weight,
      bool? isDropShip,
      double? processedOn,
      bool? isAlternateReturnAddress,
      String? moliVehicleType,
      String? drivername,
      String? moliTransportDirection,
      String? moliRucTransportista,
      String? driverid,
      String? moliDistancia,
      String? vehicle,
      String? vehicleid,
      DateTime? moliEndTransfer,
      DateTime? moliStartTransfer,
      String? moliTransportista,
      String? modelName,
      List<Line>? lines,
    }) {
      return Shipment(
        id: id ?? this.id,
        uid: uid ?? this.uid,
        description: description ?? this.description,
        movementType: movementType ?? this.movementType,
        movementDate: movementDate ?? this.movementDate,
        processed: processed ?? this.processed,
        adClientId: adClientId ?? this.adClientId,
        adOrgId: adOrgId ?? this.adOrgId,
        isActive: isActive ?? this.isActive,
        created: created ?? this.created,
        createdBy: createdBy ?? this.createdBy,
        updated: updated ?? this.updated,
        updatedBy: updatedBy ?? this.updatedBy,
        isSoTrx: isSoTrx ?? this.isSoTrx,
        documentNo: documentNo ?? this.documentNo,
        cDocTypeId: cDocTypeId ?? this.cDocTypeId,
        isPrinted: isPrinted ?? this.isPrinted,
        dateAcct: dateAcct ?? this.dateAcct,
        cBPartnerId: cBPartnerId ?? this.cBPartnerId,
        cBPartnerLocationId: cBPartnerLocationId ?? this.cBPartnerLocationId,
        adUserId: adUserId ?? this.adUserId,
        mWarehouseId: mWarehouseId ?? this.mWarehouseId,
        deliveryRule: deliveryRule ?? this.deliveryRule,
        freightCostRule: freightCostRule ?? this.freightCostRule,
        freightAmt: freightAmt ?? this.freightAmt,
        deliveryViaRule: deliveryViaRule ?? this.deliveryViaRule,
        chargeAmt: chargeAmt ?? this.chargeAmt,
        priorityRule: priorityRule ?? this.priorityRule,
        cOrderId: cOrderId ?? this.cOrderId,
        dateOrdered: dateOrdered ?? this.dateOrdered,
        docStatus: docStatus ?? this.docStatus,
        sendEMail: sendEMail ?? this.sendEMail,
        salesRepId: salesRepId ?? this.salesRepId,
        noPackages: noPackages ?? this.noPackages,
        isInTransit: isInTransit ?? this.isInTransit,
        isApproved: isApproved ?? this.isApproved,
        isInDispute: isInDispute ?? this.isInDispute,
        volume: volume ?? this.volume,
        weight: weight ?? this.weight,
        isDropShip: isDropShip ?? this.isDropShip,
        processedOn: processedOn ?? this.processedOn,
        isAlternateReturnAddress: isAlternateReturnAddress ?? this.isAlternateReturnAddress,
        moliVehicleType: moliVehicleType ?? this.moliVehicleType,
        drivername: drivername ?? this.drivername,
        moliTransportDirection: moliTransportDirection ?? this.moliTransportDirection,
        moliRucTransportista: moliRucTransportista ?? this.moliRucTransportista,
        driverid: driverid ?? this.driverid,
        moliDistancia: moliDistancia ?? this.moliDistancia,
        vehicle: vehicle ?? this.vehicle,
        vehicleid: vehicleid ?? this.vehicleid,
        moliEndTransfer: moliEndTransfer ?? this.moliEndTransfer,
        moliStartTransfer: moliStartTransfer ?? this.moliStartTransfer,
        moliTransportista: moliTransportista ?? this.moliTransportista,
        modelName: modelName ?? this.modelName,
        lines: lines ?? this.lines,
      );
    }
}