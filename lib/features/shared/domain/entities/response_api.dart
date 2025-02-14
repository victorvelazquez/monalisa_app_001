import '../../../m_inout/domain/entities/m_in_out.dart';

class ResponseApi {
    int? pageCount;
    int? recordsSize;
    int? skipRecords;
    int? rowCount;
    int? arrayCount;
    List<MInOut>? records;

    ResponseApi({
        this.pageCount,
        this.recordsSize,
        this.skipRecords,
        this.rowCount,
        this.arrayCount,
        this.records,
    });

    factory ResponseApi.fromJson(Map<String, dynamic> json) => ResponseApi(
        pageCount: json["page-count"],
        recordsSize: json["records-size"],
        skipRecords: json["skip-records"],
        rowCount: json["row-count"],
        arrayCount: json["array-count"],
        records: List<MInOut>.from(json["records"].map((x) => MInOut.fromJson(x))),        
    );
}