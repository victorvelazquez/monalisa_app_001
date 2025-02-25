import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/line.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out_confirm.dart';
import 'package:monalisa_app_001/features/m_inout/domain/repositories/m_in_out_repositiry.dart';
import '../../domain/entities/barcode.dart';
import '../../domain/entities/line_confirm.dart';
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
          mInOutList: [],
          doc: '',
          scanBarcodeListTotal: [],
          scanBarcodeListUnique: [],
          linesOver: [],
          uniqueView: false,
          viewMInOut: false,
        ));

  void setIsSOTrx(String value) {
    if (value == 'shipment') {
      state = state.copyWith(
        isSOTrx: true,
        mInOutType: MInOutType.shipment,
        title: 'Shipment',
      );
    } else if (value == 'shipmentconfirm') {
      state = state.copyWith(
        isSOTrx: true,
        mInOutType: MInOutType.shipmentConfirm,
        title: 'Shipment Confirm',
      );
    } else if (value == 'pickconfirm') {
      state = state.copyWith(
        isSOTrx: true,
        mInOutType: MInOutType.pickConfirm,
        title: 'Pick Confirm',
      );
    } else if (value == 'receipt') {
      state = state.copyWith(
        isSOTrx: false,
        mInOutType: MInOutType.receipt,
        title: 'Receipt',
      );
    } else if (value == 'receiptconfirm') {
      state = state.copyWith(
        isSOTrx: false,
        mInOutType: MInOutType.receiptConfirm,
        title: 'Receipt Confirm',
      );
    } else if (value == 'qaconfirm') {
      state = state.copyWith(
        isSOTrx: false,
        mInOutType: MInOutType.qaConfirm,
        title: 'QA Confirm',
      );
    }
  }

  Future<void> getMInOutList(WidgetRef ref) async {
    state = state.copyWith(isLoadingMInOutList: true, errorMessage: '');
    try {
      final mInOutResponse = await mInOutRepository.getMInOutList(ref);
      if (mInOutResponse.isEmpty) {
        state = state.copyWith(
          mInOutList: [],
          isLoadingMInOutList: false,
        );
        return;
      }
      state = state.copyWith(
        mInOutList: mInOutResponse,
        isLoadingMInOutList: false,
      );
    } catch (e) {
      state = state.copyWith(
        mInOutList: [],
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isLoadingMInOutList: false,
      );
    }
  }

  Future<List<MInOutConfirm>> getMInOutConfirmList(
      int mInOutId, WidgetRef ref) async {
    try {
      final mInOutConfirmResponse =
          await mInOutRepository.getMInOutConfirmList(mInOutId, ref);
      if (mInOutConfirmResponse.isEmpty) {
        return [];
      }
      return mInOutConfirmResponse;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
      );
      return [];
    }
  }

  void onDocChange(String value) {
    if (value.trim().isNotEmpty) {
      state = state.copyWith(doc: value, errorMessage: '');
    }
  }

  Future<MInOut> getMInOutAndLine(WidgetRef ref) async {
    if (state.doc.trim().isEmpty) {
      state = state.copyWith(errorMessage: 'Por favor ingrese un número de documento válido');
      throw Exception('Por favor ingrese un número de documento válido');
    }
    if (state.mInOutType == MInOutType.shipment ||
        state.mInOutType == MInOutType.receipt) {
      state =
          state.copyWith(isLoading: true, viewMInOut: true, errorMessage: '');
    }

    try {
      final mInOutResponse =
          await mInOutRepository.getMInOutAndLine(state.doc, ref);
      final filteredLines = mInOutResponse.lines
          .where((line) => line.mProductId?.id != null)
          .toList();
      state = state.copyWith(
        viewMInOut: state.mInOutType == MInOutType.receipt ||
                state.mInOutType == MInOutType.shipment
            ? true
            : false,
        mInOut: mInOutResponse.copyWith(lines: filteredLines),
        isLoading: false,
      );
      return mInOutResponse;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isLoading: false,
        viewMInOut: false,
      );
      throw Exception(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<MInOutConfirm> getMInOutConfirmAndLine(
      int mInOutConfirmId, WidgetRef ref) async {
    state = state.copyWith(isLoading: true, viewMInOut: true, errorMessage: '');
    try {
      final mInOutConfirmResponse =
          await mInOutRepository.getMInOutConfirmAndLine(mInOutConfirmId, ref);

      final updatedLines = state.mInOut!.lines.map((line) {
        final matchingConfirmLine =
            mInOutConfirmResponse.linesConfirm.firstWhere(
          (confirmLine) =>
              confirmLine.mInOutLineId!.id.toString() == line.id.toString(),
          orElse: () => LineConfirm(id: -1),
        );
        return line.copyWith(
          confirmId:
              matchingConfirmLine.id! > 0 ? matchingConfirmLine.id : null,
          targetQty: matchingConfirmLine.targetQty,
          confirmedQty: matchingConfirmLine.confirmedQty,
          confirmDifferenceQty: matchingConfirmLine.differenceQty,
          confirmScrappedQty: matchingConfirmLine.scrappedQty,
        );
      }).toList();

      final filteredLines =
          updatedLines.where((line) => line.confirmId != null).toList();

      state = state.copyWith(
        mInOutConfirm: mInOutConfirmResponse,
        mInOut: state.mInOut!.copyWith(lines: filteredLines),
        isLoading: false,
      );
      return mInOutConfirmResponse;
    } catch (e) {
      state = state.copyWith(
        errorMessage: e.toString().replaceAll('Exception: ', ''),
        isLoading: false,
        viewMInOut: false,
      );
      throw Exception(e.toString());
    }
  }

  void clearMInOutData() {
    state = state.copyWith(
      doc: '',
      mInOut: state.mInOut?.copyWith(id: null, lines: null),
      mInOutList: [],
      mInOutConfirm:
          state.mInOutConfirm?.copyWith(id: null, linesConfirm: null),
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
    final double parsedValue = double.tryParse(value) ?? 0;
    state = state.copyWith(manualQty: parsedValue);
  }

  void onManualScrappedChange(String value) {
    final double parsedValue = double.tryParse(value) ?? 0;
    state = state.copyWith(scrappedQty: parsedValue.toDouble());
  }

  void confirmManualLine(Line line) {
    final List<Line> updatedLines = state.mInOut!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      final status = _getManualStatus(line);
      updatedLines[index] = line.copyWith(
          manualQty: state.manualQty,
          confirmScrappedQty: state.scrappedQty,
          verifiedStatus: status);
      state =
          state.copyWith(mInOut: state.mInOut!.copyWith(lines: updatedLines));
      updatedMInOutLine('');
    }
  }

  void resetManualLine(Line line) {
    final List<Line> updatedLines = state.mInOut!.lines;
    final int index = updatedLines.indexWhere((l) => l.id == line.id);
    if (index != -1) {
      updatedLines[index] = line.copyWith(
          manualQty: 0, confirmScrappedQty: 0, verifiedStatus: 'pending');
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
      final mInOutResponse = await mInOutRepository.setDocAction(ref);
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
    double totalQty = 0;
    if (state.mInOutType == MInOutType.shipment ||
        state.mInOutType == MInOutType.receipt) {
      totalQty = line.movementQty!;
    } else {
      totalQty = line.targetQty!;
    }
    if (state.manualQty == totalQty) {
      return 'manually-correct';
    } else if (state.manualQty < totalQty) {
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

enum MInOutType {
  shipment,
  shipmentConfirm,
  receipt,
  receiptConfirm,
  pickConfirm,
  qaConfirm
}

class MInOutStatus {
  final String doc;
  final MInOutType mInOutType;
  final MInOut? mInOut;
  final List<MInOut> mInOutList;
  final MInOutConfirm? mInOutConfirm;
  final bool isSOTrx;
  final String title;
  final List<Barcode> scanBarcodeListTotal;
  final List<Barcode> scanBarcodeListUnique;
  final List<Barcode> linesOver;
  final bool viewMInOut;
  final bool uniqueView;
  final String orderBy;
  final double manualQty;
  final double scrappedQty;
  final String errorMessage;
  final bool isLoading;
  final bool isLoadingMInOutList;

  MInOutStatus({
    this.doc = '',
    this.mInOutType = MInOutType.shipment,
    this.mInOut,
    this.mInOutList = const [],
    this.mInOutConfirm,
    this.isSOTrx = false,
    this.title = 'Shipment',
    required this.scanBarcodeListTotal,
    required this.scanBarcodeListUnique,
    this.linesOver = const [],
    this.viewMInOut = false,
    this.uniqueView = false,
    this.orderBy = '',
    this.manualQty = 0,
    this.scrappedQty = 0,
    this.errorMessage = '',
    this.isLoading = false,
    this.isLoadingMInOutList = false,
  });

  MInOutStatus copyWith({
    String? doc,
    MInOutType? mInOutType,
    List<MInOut>? mInOutList,
    MInOut? mInOut,
    MInOutConfirm? mInOutConfirm,
    bool? isSOTrx,
    String? title,
    List<Barcode>? scanBarcodeListTotal,
    List<Barcode>? scanBarcodeListUnique,
    List<Barcode>? linesOver,
    bool? viewMInOut,
    bool? uniqueView,
    String? orderBy,
    double? manualQty,
    double? scrappedQty,
    String? errorMessage,
    bool? isLoading,
    bool? isLoadingMInOutList,
  }) =>
      MInOutStatus(
        doc: doc ?? this.doc,
        mInOutType: mInOutType ?? this.mInOutType,
        mInOutList: mInOutList ?? this.mInOutList,
        mInOut: mInOut ?? this.mInOut,
        mInOutConfirm: mInOutConfirm ?? this.mInOutConfirm,
        isSOTrx: isSOTrx ?? this.isSOTrx,
        title: title ?? this.title,
        scanBarcodeListTotal: scanBarcodeListTotal ?? this.scanBarcodeListTotal,
        scanBarcodeListUnique:
            scanBarcodeListUnique ?? this.scanBarcodeListUnique,
        linesOver: linesOver ?? this.linesOver,
        viewMInOut: viewMInOut ?? this.viewMInOut,
        orderBy: orderBy ?? this.orderBy,
        manualQty: manualQty ?? this.manualQty,
        scrappedQty: scrappedQty ?? this.scrappedQty,
        uniqueView: uniqueView ?? this.uniqueView,
        errorMessage: errorMessage ?? this.errorMessage,
        isLoading: isLoading ?? this.isLoading,
        isLoadingMInOutList: isLoadingMInOutList ?? this.isLoadingMInOutList,
      );
}
