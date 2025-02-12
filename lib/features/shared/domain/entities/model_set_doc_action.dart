class ModelSetDocAction {
  String? serviceType;
  String? tableName;
  int? recordId;
  String? docAction;

  ModelSetDocAction({
    this.serviceType,
    this.tableName,
    this.recordId,
    this.docAction,
  });

  // factory ModelSetDocAction.jsonToEntity(Map<String, dynamic> json) =>
  //     ModelSetDocAction(
  //       serviceType: json["serviceType"],
  //       tableName: json["tableName"],
  //       recordId: json["recordID"],
  //       docAction: json["docAction"],
  //     );

  ModelSetDocAction copyWith({
    String? serviceType,
    String? tableName,
    int? recordId,
    String? docAction,
  }) =>
      ModelSetDocAction(
        serviceType: serviceType ?? this.serviceType,
        tableName: tableName ?? this.tableName,
        recordId: recordId ?? this.recordId,
        docAction: docAction ?? this.docAction,
      );
}
