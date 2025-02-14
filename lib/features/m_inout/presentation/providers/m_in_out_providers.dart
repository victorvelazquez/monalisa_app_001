import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/line.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/repositories/m_in_out_repositiry.dart';
import '../../domain/entities/barcode.dart';
import '../../infrastructure/repositories/m_in_out_repository_impl.dart';

final mInOutProvider =
    StateNotifierProvider<MInOutNotifier, MInOutStatus>((ref) {
  return MInOutNotifier(mInOutRepository: MInOutRepositoryImpl());
});

class MInOutNotifier extends StateNotifier<MInOutStatus> {
  final MInOutRepository mInOutRepository;
  final ScrollController scanBarcodeListScrollController = ScrollController();

  MInOutNotifier({required this.mInOutRepository})
      : super(MInOutStatus(
          scanBarcodeListTotal: [],
          scanBarcodeListUnique: [],
          linesOver: [],
          uniqueView: false,
          viewMInOut: false,
        ));

  void setIsSOTrx(String value) {
    if (value == 'shipment') {
      state = state.copyWith(isSOTrx: true, title: 'Shipment');
    } else {
      state = state.copyWith(isSOTrx: false, title: 'Receipt');
    }
  }

  void onDocChange(String value) {
    if (value.trim().isNotEmpty) {
      state = state.copyWith(doc: value, errorMessage: '');
    }
  }

  Future<void> getMInOutAndLine(WidgetRef ref) async {
    state = state.copyWith(isLoading: true, errorMessage: '');
    if (state.doc.trim().isEmpty) {
      state = state.copyWith(
        errorMessage: 'El documento no puede estar vacío',
        isLoading: false,
      );
      return;
    }

    try {
      final mInOutResponse = await mInOutRepository.getMInOutAndLine(
          state.doc, state.isSOTrx, ref);
      final filteredLines = mInOutResponse.lines
          .where((line) => line.mProductId?.id != null)
          .toList();
      state = state.copyWith(
        mInOut: mInOutResponse.copyWith(lines: filteredLines),
        isLoading: false,
        viewMInOut: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        viewMInOut: false,
        isLoading: false,
      );
    }
  }

  void clearMInOutData() {
    state = state.copyWith(
      doc: '',
      mInOut: state.mInOut?.copyWith(id: null, lines: null),
      isSOTrx: false,
      scanBarcodeListTotal: [],
      scanBarcodeListUnique: [],
      linesOver: [],
      viewMInOut: false,
      uniqueView: false,
      orderBy: 'line',
      errorMessage: '',
      isLoading: false,
    );
  }

  void onManualQuantityChange(String value) {
    final int parsedValue = int.tryParse(value) ?? 0;
    state = state.copyWith(manualQty: parsedValue);
  }

  void confirmManualLine(Line line) {
    final List<Line> updatedLines = state.mInOut!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      final status = _getManualStatus(line);
      updatedLines[index] =
          line.copyWith(manualQty: state.manualQty, verifiedStatus: status);
      state =
          state.copyWith(mInOut: state.mInOut!.copyWith(lines: updatedLines));
      updatedMInOutLine('');
    }
  }

  void resetManualLine(Line line) {
    final List<Line> updatedLines = state.mInOut!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      updatedLines[index] =
          line.copyWith(manualQty: 0, verifiedStatus: 'pending');
      state =
          state.copyWith(mInOut: state.mInOut!.copyWith(lines: updatedLines));
      updatedMInOutLine('');
    }
  }

  bool isConfirmMInOut() {
    return state.mInOut?.lines.every((line) =>
            line.verifiedStatus == 'correct' ||
            line.verifiedStatus == 'manually-correct') ??
        false;
  }

  Future<void> setDocAction(WidgetRef ref) async {
    state =
        state.copyWith(isLoading: true, viewMInOut: false, errorMessage: '');
    if (state.mInOut?.id == null) {
      state = state.copyWith(
        errorMessage: 'MInOut ID is null',
        isLoading: false,
        viewMInOut: true,
      );
      return;
    }
    try {
      final mInOutResponse = await mInOutRepository.setDocAction(
          state.mInOut!, state.isSOTrx, ref);
      state = state.copyWith(
        mInOut: mInOutResponse.copyWith(lines: state.mInOut!.lines),
        isLoading: false,
        viewMInOut: true,
      );
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        viewMInOut: true,
        isLoading: false,
      );
    }
  }

  void addBarcode(String code) {
    if (code.trim().isEmpty) return;
    final List<Barcode> updatedTotalList = [...state.scanBarcodeListTotal];
    final existingBarcodes =
        updatedTotalList.where((barcode) => barcode.code == code).toList();

    if (existingBarcodes.isNotEmpty) {
      final int newRepetitions = existingBarcodes.first.repetitions + 1;
      for (int i = 0; i < updatedTotalList.length; i++) {
        if (updatedTotalList[i].code == code) {
          updatedTotalList[i] =
              updatedTotalList[i].copyWith(repetitions: newRepetitions);
        }
      }
      updatedTotalList.add(Barcode(
        index: updatedTotalList.length + 1,
        code: code,
        repetitions: newRepetitions,
        coloring: false,
      ));
    } else {
      updatedTotalList.add(Barcode(
        index: updatedTotalList.length + 1,
        code: code,
        repetitions: 1,
        coloring: false,
      ));
    }

    updatedBarcodeList(updatedTotalList: updatedTotalList, barcode: code);
    moveScrollToBottom();
  }

  void removeBarcode({required Barcode barcode, bool isOver = false}) {
    final int index = barcode.index - 1;
    if (index < 0 || index >= state.scanBarcodeListTotal.length) return;

    final List<Barcode> updatedTotalList = [...state.scanBarcodeListTotal];
    if (state.uniqueView || isOver) {
      updatedTotalList.removeWhere((item) => item.code == barcode.code);
    } else {
      final barcodeToRemove = updatedTotalList[index];
      updatedTotalList.removeAt(index);
      int newRepetitions = barcodeToRemove.repetitions - 1;
      for (int i = 0; i < updatedTotalList.length; i++) {
        if (updatedTotalList[i].code == barcodeToRemove.code) {
          updatedTotalList[i] =
              updatedTotalList[i].copyWith(repetitions: newRepetitions);
        }
      }
    }

    final filteredTotalList =
        updatedTotalList.where((barcode) => barcode.repetitions > 0).toList();
    updatedBarcodeList(
        updatedTotalList: filteredTotalList, barcode: barcode.code);
    moveScrollToBottom();
  }

  void updatedBarcodeList(
      {required List<Barcode> updatedTotalList, required String barcode}) {
    for (int i = 0; i < updatedTotalList.length; i++) {
      updatedTotalList[i] = updatedTotalList[i].copyWith(index: i + 1);
    }

    final Map<String, Barcode> uniqueMap = {};
    for (final barcode in updatedTotalList) {
      if (!uniqueMap.containsKey(barcode.code) ||
          uniqueMap[barcode.code]!.repetitions < barcode.repetitions) {
        uniqueMap[barcode.code] =
            barcode.copyWith(repetitions: barcode.repetitions);
      }
    }

    final List<Barcode> updatedUniqueList = uniqueMap.values.toList();
    for (int i = 0; i < updatedUniqueList.length; i++) {
      updatedUniqueList[i] = updatedUniqueList[i].copyWith(index: i + 1);
    }

    state = state.copyWith(
      scanBarcodeListTotal: updatedTotalList,
      scanBarcodeListUnique: updatedUniqueList,
    );
    updatedMInOutLine(barcode);
  }

  void updatedMInOutLine(String barcode) {
    if (state.mInOut != null && state.viewMInOut) {
      List<Line> lines = state.mInOut!.lines;
      List<Barcode> linesOver = [];
      for (int i = 0; i < lines.length; i++) {
        if ((lines[i].verifiedStatus != 'manually-correct' &&
                lines[i].verifiedStatus != 'manually-minor' &&
                lines[i].verifiedStatus != 'manually-exceeds') ||
            lines[i].upc == barcode) {
          lines[i] = lines[i].copyWith(
              verifiedStatus: 'pending', scanningQty: 0, manualQty: 0);
        }
      }
      for (final barcode in state.scanBarcodeListUnique) {
        final lineIndex = lines.indexWhere((line) => line.upc == barcode.code);
        if (lineIndex != -1) {
          final line = lines[lineIndex];
          lines[lineIndex] = _updateLineStatus(line, barcode);
        } else {
          linesOver.add(barcode.copyWith(index: linesOver.length + 1));
        }
      }
      state = state.copyWith(
          mInOut: state.mInOut!.copyWith(lines: lines), linesOver: linesOver);
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

    _toggleColoring(updatedListTotal, code);
    _toggleColoring(updatedListUnique, code);
    _toggleColoring(updatedLinesOver, code);

    state = state.copyWith(
      scanBarcodeListTotal: updatedListTotal,
      scanBarcodeListUnique: updatedListUnique,
      linesOver: updatedLinesOver,
    );
  }

  int getTotalCount() => state.scanBarcodeListTotal.length;

  int getUniqueCount() => state.scanBarcodeListUnique.length;

  void setUniqueView(bool value) {
    state = state.copyWith(uniqueView: value);
  }

  bool getUniqueView() => state.uniqueView;

  void setOrderBy(String orderBy) {
    final List<Line> sortedLines = [...state.mInOut!.lines];
    if (state.orderBy == orderBy) {
      sortedLines.sort((a, b) => a.line!.compareTo(b.line!));
      state = state.copyWith(
          orderBy: 'line', mInOut: state.mInOut!.copyWith(lines: sortedLines));
    } else {
      _sortLinesByStatus(sortedLines, orderBy);
      state = state.copyWith(
          orderBy: orderBy, mInOut: state.mInOut!.copyWith(lines: sortedLines));
    }
  }

  String _getManualStatus(Line line) {
    if (state.manualQty == line.movementQty) {
      return 'manually-correct';
    } else if (state.manualQty < line.movementQty!) {
      return 'manually-minor';
    } else {
      return 'manually-exceeds';
    }
  }

  Line _updateLineStatus(Line line, Barcode barcode) {
    if (line.verifiedStatus == 'manually-correct' ||
        line.verifiedStatus == 'manually-minor' ||
        line.verifiedStatus == 'manually-exceeds') {
      return line.copyWith(
        verifiedStatus: _getManualStatus(line),
        scanningQty: barcode.repetitions,
      );
    } else {
      if (barcode.repetitions == line.movementQty) {
        return line.copyWith(
            verifiedStatus: 'correct', scanningQty: barcode.repetitions);
      } else if (barcode.repetitions < line.movementQty!) {
        return line.copyWith(
            verifiedStatus: 'minor', scanningQty: barcode.repetitions);
      } else {
        return line.copyWith(
            verifiedStatus: 'exceeds', scanningQty: barcode.repetitions);
      }
    }
  }

  void _toggleColoring(List<Barcode> list, String code) {
    for (int i = 0; i < list.length; i++) {
      if (list[i].code == code) {
        list[i] = list[i].copyWith(coloring: !list[i].coloring);
      } else {
        list[i] = list[i].copyWith(coloring: false);
      }
    }
  }

  void _sortLinesByStatus(List<Line> lines, String orderBy) {
    final statuses = ['manually-minor', 'manually-exceeds', 'manually-correct'];
    if (orderBy == 'manually') {
      for (final status in statuses) {
        lines.sort((a, b) {
          if (a.verifiedStatus == status && b.verifiedStatus != status) {
            return -1;
          } else if (a.verifiedStatus != status && b.verifiedStatus == status) {
            return 1;
          } else {
            return 0;
          }
        });
      }
    } else {
      lines.sort((a, b) {
        if (a.verifiedStatus == orderBy && b.verifiedStatus != orderBy) {
          return -1;
        } else if (a.verifiedStatus != orderBy && b.verifiedStatus == orderBy) {
          return 1;
        } else {
          return 0;
        }
      });
    }
  }
}

class MInOutStatus {
  final String doc;
  final MInOut? mInOut;
  final bool isSOTrx;
  final String title;
  final List<Barcode> scanBarcodeListTotal;
  final List<Barcode> scanBarcodeListUnique;
  final List<Barcode> linesOver;
  final bool viewMInOut;
  final bool uniqueView;
  final String orderBy;
  final int manualQty;
  final String errorMessage;
  final bool isLoading;

  MInOutStatus({
    this.doc = '',
    this.mInOut,
    this.isSOTrx = false,
    this.title = 'Shipment',
    required this.scanBarcodeListTotal,
    required this.scanBarcodeListUnique,
    this.linesOver = const [],
    this.viewMInOut = false,
    this.uniqueView = false,
    this.orderBy = '',
    this.manualQty = 0,
    this.errorMessage = '',
    this.isLoading = false,
  });

  MInOutStatus copyWith({
    String? doc,
    MInOut? mInOut,
    bool? isSOTrx,
    String? title,
    List<Barcode>? scanBarcodeListTotal,
    List<Barcode>? scanBarcodeListUnique,
    List<Barcode>? linesOver,
    bool? viewMInOut,
    bool? uniqueView,
    String? orderBy,
    int? manualQty,
    String? errorMessage,
    bool? isLoading,
  }) =>
      MInOutStatus(
        doc: doc ?? this.doc,
        mInOut: mInOut ?? this.mInOut,
        isSOTrx: isSOTrx ?? this.isSOTrx,
        title: title ?? this.title,
        scanBarcodeListTotal: scanBarcodeListTotal ?? this.scanBarcodeListTotal,
        scanBarcodeListUnique:
            scanBarcodeListUnique ?? this.scanBarcodeListUnique,
        linesOver: linesOver ?? this.linesOver,
        viewMInOut: viewMInOut ?? this.viewMInOut,
        orderBy: orderBy ?? this.orderBy,
        manualQty: manualQty ?? this.manualQty,
        uniqueView: uniqueView ?? this.uniqueView,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
      );
}
