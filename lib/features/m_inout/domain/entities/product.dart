class Product {
  int? id;
  String? name;
  String? upc;
  String? sku;
  Product({
    this.id,
    this.name,
    this.upc,
    this.sku,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"] ?? 0,
        name: json["Name"] ?? '',
        upc: json["UPC"] ?? '',
        sku: json["SKU"] ?? '',
      );

  Product copyWith({
    int? id,
    String? name,
    String? upc,
    String? sku,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      upc: upc ?? this.upc,
      sku: sku ?? this.sku,
    );
  }
}
