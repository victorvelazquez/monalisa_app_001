import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/line.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/shipment.dart';
import 'package:monalisa_app_001/features/shipment/domain/repositories/shipment_repositiry.dart';

import '../../domain/entities/barcode.dart';
import '../../infrastructure/repositories/shipment_repository_impl.dart';

// Provider para manejar el estado de la lista de códigos de barras
final shipmentProvider =
    StateNotifierProvider<ShipmentNotifier, ShipmentStatus>((ref) {
  return ShipmentNotifier(
    shipmentRepository: ShipmentRepositoryImpl(),
  );
});

// Clase para manejar la lógica y estado
class ShipmentNotifier extends StateNotifier<ShipmentStatus> {
  final ShipmentRepository shipmentRepository;
  final ScrollController scanBarcodeListScrollController = ScrollController();

  ShipmentNotifier({
    required this.shipmentRepository,
  }) : super(
          ShipmentStatus(
            scanBarcodeListTotal: [],
            scanBarcodeListUnique: [],
            linesOver: [],
            uniqueView: false,
            viewShipment: false,
          ),
        );

  onDocChange(String value) {
    if (value.trim().isNotEmpty) {
      state = state.copyWith(
      doc: value,
      errorMessage: '',
      );
    }
  }

  Future<void> getShipmentAndLine(WidgetRef ref) async {
    if (state.doc.trim().isNotEmpty) {
      state = state.copyWith(
        isLoading: true,
        errorMessage: '',
      );
      try {
        final shipmentResponse =
            await shipmentRepository.getShipmentAndLine(state.doc, ref);
        state = state.copyWith(
          shipment: shipmentResponse,
          isLoading: false,
          viewShipment: true,
        );
      } catch (e) {
        state = state.copyWith(
          errorMessage: 'Error al obtener el shipment: ${e.toString()}',
          viewShipment: false,
          isLoading: false,
        );
      }
    }
  }

  // Método para limpiar los datos del shipment
  void clearShipmentData() {
    state = state.copyWith(
      shipment: state.shipment!.copyWith(id: null, lines: null),
      scanBarcodeListTotal: [],
      scanBarcodeListUnique: [],
      viewShipment: false,
    );
  }

  void confirmManualLine(Line line) {
    final List<Line> updatedLines = state.shipment!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      updatedLines[index] = line.copyWith(verifiedStatus: 'manually');
      state = state.copyWith(
        shipment: state.shipment!.copyWith(lines: updatedLines),
      );
    }
  }

  bool isConfirmShipment() {
    if (state.shipment != null) {
      final List<Line> lines = state.shipment!.lines;
      for (final line in lines) {
        if (line.verifiedStatus != 'correct' &&
            line.verifiedStatus != 'manually') {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  Future<void> confirmShipment() async {
    state = state.copyWith(
      isLoading: true,
      viewShipment: false,
      errorMessage: '',
    );
    try {
      // final shipmentResponse = await shipmentRepository.confirmShipment(code);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        // shipment: shipmentResponse,
        isLoading: false,
        viewShipment: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Error al confirmar el shipment: ${e.toString()}',
        viewShipment: false,
        isLoading: false,
      );
    }
  }

  // Método para agregar un código de barras
  void addBarcode(String code) {
    if (code.trim().isEmpty) return;

    // Copia de la lista actual para trabajar con ella
    final List<Barcode> updatedTotalList = [...state.scanBarcodeListTotal];

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
          coloring: false,
        ),
      );
    } else {
      // Si no existe, agregar como nuevo
      updatedTotalList.add(
        Barcode(
          index: updatedTotalList.length + 1,
          code: code,
          repetitions: 1,
          coloring: false,
        ),
      );
    }

    updatedVerifyList(updatedTotalList);

    moveScrollToBottom();
  }

  // Método para eliminar un código de barras por su índice
  void removeBarcode(Barcode barcode) {
    final int index = barcode.index - 1;
    if (index < 0 || index >= state.scanBarcodeListTotal.length) return;

    final List<Barcode> updatedTotalList = [...state.scanBarcodeListTotal];

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
    updatedVerifyList(filteredTotalList);

    moveScrollToBottom();
  }

  void updatedVerifyList(List<Barcode> updatedTotalList) {
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
      scanBarcodeListTotal: updatedTotalList,
      scanBarcodeListUnique: updatedUniqueList,
    );

    // Verificar las líneas del shipment
    if (state.shipment != null && state.viewShipment) {
      List<Line> lines = state.shipment!.lines;
      List<Barcode> linesOver = [];
      if (lines.isNotEmpty) {
        for (int i = 0; i < lines.length; i++) {
          lines[i] = lines[i].copyWith(
            verifiedStatus: 'pending',
            scanningQty: 0,
          );
        }
        for (int i = 0; i < updatedUniqueList.length; i++) {
          final barcode = updatedUniqueList[i];
          final lineIndex =
              lines.indexWhere((line) => line.upc == barcode.code);

          if (lineIndex != -1) {
            final line = lines[lineIndex];
            if (barcode.repetitions == line.movementQty) {
              lines[lineIndex] = line.copyWith(
                verifiedStatus: 'equal',
                scanningQty: barcode.repetitions,
              );
            } else if (barcode.repetitions < line.movementQty!) {
              lines[lineIndex] = line.copyWith(
                verifiedStatus: 'minor',
                scanningQty: barcode.repetitions,
              );
            } else if (barcode.repetitions > line.movementQty!) {
              lines[lineIndex] = line.copyWith(
                verifiedStatus: 'greater',
                scanningQty: barcode.repetitions,
              );
            }
          } else {
            linesOver = [
              ...linesOver,
              Barcode(
                index: linesOver.length + 1,
                code: barcode.code,
                repetitions: barcode.repetitions,
                coloring: false,
              ),
            ];
          }
        }
        // Actualizar el estado con las líneas verificadas
        state = state.copyWith(
          shipment: state.shipment!.copyWith(lines: lines),
          linesOver: linesOver,
        );
      }
    }
  }

  void moveScrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scanBarcodeListScrollController.hasClients) {
        scanBarcodeListScrollController.animateTo(
          scanBarcodeListScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void selectRepeat(String code) {
    final List<Barcode> updatedListTotal = state.scanBarcodeListTotal;
    final List<Barcode> updatedListUnique = state.scanBarcodeListUnique;
    final List<Barcode> updatedLinesOver = state.linesOver;
    for (int i = 0; i < updatedListTotal.length; i++) {
      // Verificamos si el 'code' recibido coincide con el 'code' del elemento actual
      if (updatedListTotal[i].code == code) {
        updatedListTotal[i] = updatedListTotal[i]
            .copyWith(coloring: !updatedListTotal[i].coloring);
      } else {
        updatedListTotal[i] = updatedListTotal[i].copyWith(coloring: false);
      }
    }
    for (int i = 0; i < updatedListUnique.length; i++) {
      // Verificamos si el 'code' recibido coincide con el 'code' del elemento actual
      if (updatedListUnique[i].code == code) {
        updatedListUnique[i] = updatedListUnique[i]
            .copyWith(coloring: !updatedListUnique[i].coloring);
      } else {
        updatedListUnique[i] = updatedListUnique[i].copyWith(coloring: false);
      }
    }
    for (int i = 0; i < updatedLinesOver.length; i++) {
      // Verificamos si el 'code' recibido coincide con el 'code' del elemento actual
      if (updatedLinesOver[i].code == code) {
        updatedLinesOver[i] = updatedLinesOver[i]
            .copyWith(coloring: !updatedLinesOver[i].coloring);
      } else {
        updatedLinesOver[i] = updatedLinesOver[i].copyWith(coloring: false);
      }
    }
    state = state.copyWith(
      scanBarcodeListTotal: updatedListTotal,
      scanBarcodeListUnique: updatedListUnique,
      linesOver: updatedLinesOver,
    );
  }

  int getTotalCount() {
    return state.scanBarcodeListTotal.length;
  }

  int getUniqueCount() {
    return state.scanBarcodeListUnique.length;
  }

  void setUniqueView(bool value) {
    state = state.copyWith(uniqueView: value);
  }

  bool getUniqueView() {
    return state.uniqueView;
  }
}

// Clase para manejar el estado de la lista
class ShipmentStatus {
  final List<Barcode> scanBarcodeListTotal;
  final List<Barcode> scanBarcodeListUnique;
  final List<Barcode> linesOver;
  final String doc;
  final Shipment? shipment;
  final bool viewShipment;
  final bool uniqueView;
  final String errorMessage;
  final bool isLoading;

  ShipmentStatus({
    required this.scanBarcodeListTotal,
    required this.scanBarcodeListUnique,
    this.linesOver = const [],
    this.doc = '',
    this.shipment,
    this.viewShipment = false,
    this.uniqueView = false,
    this.errorMessage = '',
    this.isLoading = false,
  });

  ShipmentStatus copyWith({
    List<Barcode>? scanBarcodeListTotal,
    List<Barcode>? scanBarcodeListUnique,
    List<Barcode>? linesOver,
    String? doc,
    Shipment? shipment,
    bool? viewShipment,
    bool? uniqueView,
    String? errorMessage,
    bool? isLoading,
  }) =>
      ShipmentStatus(
        scanBarcodeListTotal: scanBarcodeListTotal ?? this.scanBarcodeListTotal,
        scanBarcodeListUnique:
            scanBarcodeListUnique ?? this.scanBarcodeListUnique,
        linesOver: linesOver ?? this.linesOver,
        doc: doc ?? this.doc,
        shipment: shipment ?? this.shipment,
        viewShipment: viewShipment ?? this.viewShipment,
        uniqueView: uniqueView ?? this.uniqueView,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
      );
}
