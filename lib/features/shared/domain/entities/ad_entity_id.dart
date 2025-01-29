class AdEntityId {
  String? propertyLabel;
  String? id;
  String? identifier;
  String? modelName;

  AdEntityId({
    this.propertyLabel,
    this.id,
    this.identifier,
    this.modelName,
  });

  factory AdEntityId.jsonToEntity(Map<String, dynamic> json) => AdEntityId(
        propertyLabel: json["propertyLabel"],
        id: json["id"].toString(),
        identifier: json["identifier"],
        modelName: json["model-name"],
      );
}
