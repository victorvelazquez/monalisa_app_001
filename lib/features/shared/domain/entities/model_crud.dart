import 'package:monalisa_app_001/features/shared/domain/entities/field_crud.dart';

class ModelCrud {
  String? serviceType;
  String? tableName;
  int? recordId;
  String? action;
  List<FieldCrud>? dataRow;

  ModelCrud({
    this.serviceType,
    this.tableName,
    this.recordId,
    this.action,
    this.dataRow,
  });

  Map<String, dynamic> toJson() => {
        "serviceType": serviceType,
        "TableName": tableName,
        "RecordID": recordId,
        "Action": action, // "Create" or ”Update”
        "DataRow": dataRow?.map((x) => x.toJson()).toList(),
      };

  ModelCrud copyWith({
    String? serviceType,
    String? tableName,
    int? recordId,
    String? action,
    List<FieldCrud>? dataRow,
  }) =>
      ModelCrud(
        serviceType: serviceType ?? this.serviceType,
        tableName: tableName ?? this.tableName,
        recordId: recordId ?? this.recordId,
        action: action ?? this.action,
        dataRow: dataRow ?? this.dataRow,
      );
}
