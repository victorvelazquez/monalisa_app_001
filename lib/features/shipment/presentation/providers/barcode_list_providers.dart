// Provider para manejar la lista de códigos de barras
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/barcode.dart';

final barcodeListProvider =
    StateNotifierProvider<BarcodeListNotifier, List<Barcode>>((ref) {
  return BarcodeListNotifier();
});

// Clase para manejar el estado de la lista de códigos de barras
class BarcodeListNotifier extends StateNotifier<List<Barcode>> {
  final ScrollController barcodeListScrollController = ScrollController();
  int _uniqueCodes = 0;
  int _totalCodes = 0;
  BarcodeListNotifier() : super([]);

  int get uniqueCodes => _uniqueCodes;
  int get totalCodes => _totalCodes;

  // Método para agregar un código de barras
  void addBarcode(String code) {
    if (code.trim().isEmpty) return;

    // Contar cuántas veces existe el código actualmente
    final repetitionsCount =
        state.where((barcode) => barcode.code == code).length;

    if (repetitionsCount > 0) {
      // Si ya existe, actualizamos todas las ocurrencias con el nuevo valor de repeticiones
      final updatedRepetitions = repetitionsCount + 1;
      state = [
        for (final barcode in state)
          if (barcode.code == code)
            barcode.copyWith(repetitions: updatedRepetitions)
          else
            barcode,
        // Agregar el nuevo código al final con el contador actualizado
        Barcode(
          index: state.length + 1,
          code: code,
          repetitions: updatedRepetitions,
        ),
      ];
    } else {
      // Si no existe, lo agregamos como nuevo
      state = [
        ...state,
        Barcode(
          index: state.length + 1,
          code: code,
          repetitions: 1,
        ),
      ];
    }

    moveScrollToBottom();
  }

  // Método para eliminar un código de barras por su índice y actualizar las repeticiones
  void removeBarcodeByIndex(int index) {
    if (index < 0 || index >= state.length) return; // Asegurarse de que el índice sea válido

    final barcodeToRemove = state[index];
    final removedCode = barcodeToRemove.code;

    // Eliminar el ítem de la lista
    state = [
      for (int i = 0; i < state.length; i++)
        if (i != index) state[i], // Excluir el ítem en el índice especificado
    ];

    // Ahora, actualizar las repeticiones de los demás ítems con el mismo código
    state = [
      for (final barcode in state)
        if (barcode.code == removedCode)
          barcode.copyWith(
              repetitions: barcode.repetitions - 1) // Reducir las repeticiones
        else
          barcode,
    ];

    // Si después de la eliminación algún código tiene 0 repeticiones, podemos eliminarlo de la lista también.
    state = state.where((barcode) => barcode.repetitions > 0).toList();

    moveScrollToBottom();
  }

  void moveScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (barcodeListScrollController.hasClients) {
        barcodeListScrollController.animateTo(
          barcodeListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  set state(List<Barcode> value) {
    super.state = value;
    _updateMetrics();
  }

  void _updateMetrics() {
    _uniqueCodes = state.map((barcode) => barcode.code).toSet().length;
    _totalCodes = state.length;
  }
}
