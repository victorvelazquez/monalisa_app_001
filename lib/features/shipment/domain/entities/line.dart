class Line {
  int? id;
  int? line;
  int? movementQty;
  String? upc;
  String? productName;
  String? verifiedStatus;
  int? scanningQty;

  Line({
    this.id,
    this.line,
    this.movementQty,
    this.upc,
    this.productName,
    this.verifiedStatus,
    this.scanningQty,
  });

  factory Line.jsonToEntity(Map<String, dynamic> json) => Line(
        id: json["id"],
        line: json["Line"],
        movementQty: json["MovementQty"],
        upc: json["UPC"],
        productName: json["ProductName"],
      );

  Line copyWith({
    int? id,
    int? line,
    int? movementQty,
    String? upc,
    String? productName,
    String? verifiedStatus,
    int? scanningQty,
  }) {
    return Line(
      id: id ?? this.id,
      line: line ?? this.line,
      movementQty: movementQty ?? this.movementQty,
      upc: upc ?? this.upc,
      productName: productName ?? this.productName,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      scanningQty: scanningQty ?? this.scanningQty,
    );
  }
}
