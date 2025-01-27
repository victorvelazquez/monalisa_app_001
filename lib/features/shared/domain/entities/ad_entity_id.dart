class AdEntityId {
  String? propertyLabel;
  int? id;
  String? identifier;
  String? modelName;

  AdEntityId({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelName,
  });

  factory AdEntityId.fromMap(Map<String, dynamic> json) => AdEntityId(
        propertyLabel: json["propertyLabel"],
        id: json["id"],
        identifier: json["identifier"],
        modelName: json["model-name"],
      );

  Map<String, dynamic> toMap() => {
        "propertyLabel": propertyLabel,
        "id": id,
        "identifier": identifier,
        "model-name": modelName,
      };
}
