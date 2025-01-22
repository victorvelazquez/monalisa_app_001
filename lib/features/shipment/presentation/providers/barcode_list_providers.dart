import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/barcode.dart';

// Provider para manejar el estado de la lista de códigos de barras
final barcodeListProvider =
    StateNotifierProvider<BarcodeListNotifier, BarcodeListStatus>((ref) {
  return BarcodeListNotifier();
});

// Clase para manejar la lógica y estado
class BarcodeListNotifier extends StateNotifier<BarcodeListStatus> {
  final ScrollController barcodeListScrollController = ScrollController();

  BarcodeListNotifier()
      : super(
          BarcodeListStatus(
            barcodeListTotal: [],
            barcodeListUnique: [],
            uniqueView: false,
          ),
        );

  // Método para alternar entre vista única o completa
  void setUniqueView(bool value) {
    state = state.copyWith(uniqueView: value);
  }

  // Método para agregar un código de barras
  void addBarcode(String code) {
    if (code.trim().isEmpty) return;

    // Copia de la lista actual para trabajar con ella
    final List<Barcode> updatedTotalList = [...state.barcodeListTotal];

    // Buscar códigos existentes en la lista total
    final existingBarcodes =
        updatedTotalList.where((barcode) => barcode.code == code).toList();

    if (existingBarcodes.isNotEmpty) {
      // Si ya existe, actualizar todas las repeticiones
      final int newRepetitions = existingBarcodes.first.repetitions + 1;

      // Actualizar todos los códigos existentes con el nuevo número de repeticiones
      for (int i = 0; i < updatedTotalList.length; i++) {
        if (updatedTotalList[i].code == code) {
          updatedTotalList[i] =
              updatedTotalList[i].copyWith(repetitions: newRepetitions);
        }
      }

      // Agregar uno nuevo al final con el nuevo número de repeticiones
      updatedTotalList.add(
        Barcode(
          index: updatedTotalList.length + 1,
          code: code,
          repetitions: newRepetitions,
        ),
      );
    } else {
      // Si no existe, agregar como nuevo
      updatedTotalList.add(
        Barcode(
          index: updatedTotalList.length + 1,
          code: code,
          repetitions: 1,
        ),
      );
    }

    updatedList(updatedTotalList);

    moveScrollToBottom();
  }

  // Método para eliminar un código de barras por su índice
  void removeBarcode(Barcode barcode) {
    final int index = barcode.index - 1;
    if (index < 0 || index >= state.barcodeListTotal.length) return;

    final List<Barcode> updatedTotalList = [...state.barcodeListTotal];

    if (state.uniqueView) {
      // Eliminar todos los elementos que coincidan con el código
      updatedTotalList.removeWhere((item) => item.code == barcode.code);
    } else {
      // Eliminar solo el elemento especificado en el índice
      final barcodeToRemove = updatedTotalList[index];
      updatedTotalList.removeAt(index);

      // Actualizar repeticiones para los elementos restantes con el mismo código
      int newRepetitions = barcodeToRemove.repetitions - 1;
      for (int i = 0; i < updatedTotalList.length; i++) {
        if (updatedTotalList[i].code == barcodeToRemove.code) {
          updatedTotalList[i] = updatedTotalList[i].copyWith(
            repetitions: newRepetitions,
          );
        }
      }
    }

    // Remover elementos con 0 repeticiones
    final filteredTotalList =
        updatedTotalList.where((barcode) => barcode.repetitions > 0).toList();

    // Actualizar las listas
    updatedList(filteredTotalList);

    moveScrollToBottom();
  }

  void updatedList(List<Barcode> updatedTotalList) {
    // Reasignar índices a la lista total
    for (int i = 0; i < updatedTotalList.length; i++) {
      updatedTotalList[i] = updatedTotalList[i].copyWith(index: i + 1);
    }

    // Generar la lista única con la mayor cantidad de repeticiones para cada código
    final Map<String, Barcode> uniqueMap = {};
    for (final barcode in updatedTotalList) {
      if (!uniqueMap.containsKey(barcode.code) ||
          uniqueMap[barcode.code]!.repetitions < barcode.repetitions) {
        uniqueMap[barcode.code] =
            barcode.copyWith(repetitions: barcode.repetitions);
      }
    }

// Crear lista única con índices consecutivos
    final List<Barcode> updatedUniqueList = uniqueMap.values.toList();
    for (int i = 0; i < updatedUniqueList.length; i++) {
      updatedUniqueList[i] = updatedUniqueList[i].copyWith(index: i + 1);
    }
    // Actualizar el estado
    state = state.copyWith(
      barcodeListTotal: updatedTotalList,
      barcodeListUnique: updatedUniqueList,
    );
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

  int getTotalCount() {
    return state.barcodeListTotal.length;
  }

  int getUniqueCount() {
    return state.barcodeListUnique.length;
  }

  bool getUniqueView() {
    return state.uniqueView;
  }
}

// Clase para manejar el estado de la lista
class BarcodeListStatus {
  final List<Barcode> barcodeListTotal;
  final List<Barcode> barcodeListUnique;
  final bool uniqueView;

  BarcodeListStatus({
    required this.barcodeListTotal,
    required this.barcodeListUnique,
    this.uniqueView = false,
  });

  BarcodeListStatus copyWith({
    List<Barcode>? barcodeListTotal,
    List<Barcode>? barcodeListUnique,
    bool? uniqueView,
  }) =>
      BarcodeListStatus(
        barcodeListTotal: barcodeListTotal ?? this.barcodeListTotal,
        barcodeListUnique: barcodeListUnique ?? this.barcodeListUnique,
        uniqueView: uniqueView ?? this.uniqueView,
      );
}
