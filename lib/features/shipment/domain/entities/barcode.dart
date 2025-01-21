class Barcode {
  final int index;
  final String code;
  final int repetitions;

  Barcode({
    required this.index,
    required this.code,
    required this.repetitions,
  });

  Barcode copyWith({
    int? index,
    String? code,
    int? repetitions,
  }) {
    return Barcode(
      index: index ?? this.index,
      code: code ?? this.code,
      repetitions: repetitions ?? this.repetitions,
    );
  }
}
