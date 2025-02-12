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
      doc: '',
      shipment: state.shipment!.copyWith(id: null, lines: null),
      scanBarcodeListTotal: [],
      scanBarcodeListUnique: [],
      linesOver: [],
      viewShipment: false,
      uniqueView: false,
      orderBy: 'line',
      errorMessage: '',
      isLoading: false,
    );
  }

  onManualQuantityChange(String value) {
    if (value.trim().isNotEmpty) {
      final int parsedValue = int.tryParse(value) ?? 0;
      state = state.copyWith(
        manualQty: parsedValue,
      );
    }
  }

  void confirmManualLine(Line line) {
    final List<Line> updatedLines = state.shipment!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    String status = 'manually-correct';
    if (index != -1) {
      if (state.manualQty == line.movementQty) {
        status = 'manually-correct';
      } else if (state.manualQty < line.movementQty!) {
        status = 'manually-minor';
      } else if (state.manualQty > line.movementQty!) {
        status = 'manually-exceeds';
      }
      updatedLines[index] =
          line.copyWith(manualQty: state.manualQty, verifiedStatus: status);
      state = state.copyWith(
        shipment: state.shipment!.copyWith(lines: updatedLines),
      );
      updatedShipmentLine('');
    }
  }

  void resetManualLine(Line line) {
    final List<Line> updatedLines = state.shipment!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      updatedLines[index] =
          line.copyWith(manualQty: 0, verifiedStatus: 'pending');
      state = state.copyWith(
        shipment: state.shipment!.copyWith(lines: updatedLines),
      );
      updatedShipmentLine('');
    }
  }

  bool isConfirmShipment() {
    if (state.shipment != null) {
      final List<Line> lines = state.shipment!.lines;
      for (final line in lines) {
        if (line.verifiedStatus != 'correct' &&
            line.verifiedStatus != 'manually-correct') {
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

    updatedBarcodeList(updatedTotalList: updatedTotalList, barcode: code);

    moveScrollToBottom();
  }

  // Método para eliminar un código de barras por su índice
  void removeBarcode({required Barcode barcode, bool isOver = false}) {
    final int index = barcode.index - 1;
    if (index < 0 || index >= state.scanBarcodeListTotal.length) return;

    final List<Barcode> updatedTotalList = [...state.scanBarcodeListTotal];

    if (state.uniqueView || isOver) {
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
    updatedBarcodeList(
        updatedTotalList: filteredTotalList, barcode: barcode.code);

    moveScrollToBottom();
  }

  void updatedBarcodeList(
      {required List<Barcode> updatedTotalList, required String barcode}) {
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
    updatedShipmentLine(barcode);
  }

  void updatedShipmentLine(String barcode) {
    // Verificar las líneas del shipment
    if (state.shipment != null && state.viewShipment) {
      List<Line> lines = state.shipment!.lines;
      List<Barcode> linesOver = [];
      if (lines.isNotEmpty) {
        for (int i = 0; i < lines.length; i++) {
          if ((lines[i].verifiedStatus != 'manually-correct' &&
                  lines[i].verifiedStatus != 'manually-minor' &&
                  lines[i].verifiedStatus != 'manually-exceeds') ||
              lines[i].upc == barcode) {
            lines[i] = lines[i].copyWith(
              verifiedStatus: 'pending',
              scanningQty: 0,
              manualQty: 0,
            );
          }
        }
        for (int i = 0; i < state.scanBarcodeListUnique.length; i++) {
          final barcode = state.scanBarcodeListUnique[i];
          final lineIndex =
              lines.indexWhere((line) => line.upc == barcode.code);
          if (lineIndex != -1) {
            final line = lines[lineIndex];
            if (line.verifiedStatus == 'manually-correct' ||
                line.verifiedStatus == 'manually-minor' ||
                line.verifiedStatus == 'manually-exceeds') {
              if (line.manualQty == line.movementQty) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'manually-correct',
                  scanningQty: barcode.repetitions,
                );
              } else if (line.manualQty! < line.movementQty!) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'manually-minor',
                  scanningQty: barcode.repetitions,
                );
              } else if (line.manualQty! > line.movementQty!) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'manually-exceeds',
                  scanningQty: barcode.repetitions,
                );
              }
            } else {
              if (barcode.repetitions == line.movementQty) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'correct',
                  scanningQty: barcode.repetitions,
                );
              } else if (barcode.repetitions < line.movementQty!) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'minor',
                  scanningQty: barcode.repetitions,
                );
              } else if (barcode.repetitions > line.movementQty!) {
                lines[lineIndex] = line.copyWith(
                  verifiedStatus: 'exceeds',
                  scanningQty: barcode.repetitions,
                );
              }
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

  void setOrderBy(String orderBy) {
    if (state.orderBy == orderBy) {
      final List<Line> sortedLines = [...state.shipment!.lines];
      sortedLines.sort((a, b) => a.line!.compareTo(b.line!));
      state = state.copyWith(
        orderBy: 'line',
        shipment: state.shipment!.copyWith(lines: sortedLines),
      );
    } else {
      final List<Line> sortedLines = [...state.shipment!.lines];
      if (orderBy == 'manually') {
        orderBy = 'manually-minor';
        sortedLines.sort((a, b) {
          if (a.verifiedStatus == orderBy && b.verifiedStatus != orderBy) {
            return -1;
          } else if (a.verifiedStatus != orderBy &&
              b.verifiedStatus == orderBy) {
            return 1;
          } else {
            return 0;
          }
        });
        orderBy = 'manually-exceeds';
        sortedLines.sort((a, b) {
          if (a.verifiedStatus == orderBy && b.verifiedStatus != orderBy) {
            return -1;
          } else if (a.verifiedStatus != orderBy &&
              b.verifiedStatus == orderBy) {
            return 1;
          } else {
            return 0;
          }
        });
        orderBy = 'manually-correct';
        sortedLines.sort((a, b) {
          if (a.verifiedStatus == orderBy && b.verifiedStatus != orderBy) {
            return -1;
          } else if (a.verifiedStatus != orderBy &&
              b.verifiedStatus == orderBy) {
            return 1;
          } else {
            return 0;
          }
        });
      } else {
        sortedLines.sort((a, b) {
          if (a.verifiedStatus == orderBy && b.verifiedStatus != orderBy) {
            return -1;
          } else if (a.verifiedStatus != orderBy &&
              b.verifiedStatus == orderBy) {
            return 1;
          } else {
            return 0;
          }
        });
      }

      state = state.copyWith(
        orderBy: orderBy,
        shipment: state.shipment!.copyWith(lines: sortedLines),
      );
    }
  }
}

// Clase para manejar el estado de la lista
class ShipmentStatus {
  final String doc;
  final Shipment? shipment;
  final List<Barcode> scanBarcodeListTotal;
  final List<Barcode> scanBarcodeListUnique;
  final List<Barcode> linesOver;
  final bool viewShipment;
  final bool uniqueView;
  final String orderBy;
  final int manualQty;
  final String errorMessage;
  final bool isLoading;

  ShipmentStatus({
    this.doc = '',
    this.shipment,
    required this.scanBarcodeListTotal,
    required this.scanBarcodeListUnique,
    this.linesOver = const [],
    this.viewShipment = false,
    this.uniqueView = false,
    this.orderBy = '',
    this.manualQty = 0,
    this.errorMessage = '',
    this.isLoading = false,
  });

  ShipmentStatus copyWith({
    String? doc,
    Shipment? shipment,
    List<Barcode>? scanBarcodeListTotal,
    List<Barcode>? scanBarcodeListUnique,
    List<Barcode>? linesOver,
    bool? viewShipment,
    bool? uniqueView,
    String? orderBy,
    int? manualQty,
    String? errorMessage,
    bool? isLoading,
  }) =>
      ShipmentStatus(
        doc: doc ?? this.doc,
        shipment: shipment ?? this.shipment,
        scanBarcodeListTotal: scanBarcodeListTotal ?? this.scanBarcodeListTotal,
        scanBarcodeListUnique:
            scanBarcodeListUnique ?? this.scanBarcodeListUnique,
        linesOver: linesOver ?? this.linesOver,
        viewShipment: viewShipment ?? this.viewShipment,
        orderBy: orderBy ?? this.orderBy,
        manualQty: manualQty ?? this.manualQty,
        uniqueView: uniqueView ?? this.uniqueView,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
      );
}
