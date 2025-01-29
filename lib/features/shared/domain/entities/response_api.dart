import '../../../shipment/domain/entities/shipment.dart';

class ResponseApi {
    int? pageCount;
    int? recordsSize;
    int? skipRecords;
    int? rowCount;
    int? arrayCount;
    List<Shipment>? records;

    ResponseApi({
        this.pageCount,
        this.recordsSize,
        this.skipRecords,
        this.rowCount,
        this.arrayCount,
        this.records,
    });

    factory ResponseApi.jsonToEntity(Map<String, dynamic> json) => ResponseApi(
        pageCount: json["page-count"],
        recordsSize: json["records-size"],
        skipRecords: json["skip-records"],
        rowCount: json["row-count"],
        arrayCount: json["array-count"],
        records: List<Shipment>.from(json["records"].map((x) => Shipment.jsonToEntity(x))),        
    );
}