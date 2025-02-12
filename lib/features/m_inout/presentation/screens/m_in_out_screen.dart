import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shared/shared.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/line.dart';
import 'package:monalisa_app_001/features/m_inout/presentation/widgets/barcode_list.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/barcode.dart';
import '../providers/m_in_out_providers.dart';
import '../widgets/enter_barcode_button.dart';

class MInOutScreen extends ConsumerWidget {
  final String? type;

  const MInOutScreen({super.key, this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mInOutState = ref.watch(mInOutProvider);
    final mInOutNotifier = ref.read(mInOutProvider.notifier);

    ref.listen(mInOutProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage)));
      }
    });

    final isShipment = type == 'shipment';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: isShipment ? 'Shipment' : 'Recept'),
              Tab(text: 'Scan'),
            ],
            isScrollable: true,
            indicatorWeight: 4,
            indicatorColor: themeColorPrimary,
            dividerColor: themeColorPrimary,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyle(
                fontSize: themeFontSizeTitle,
                fontWeight: FontWeight.bold,
                color: themeColorPrimary),
            unselectedLabelStyle: TextStyle(fontSize: themeFontSizeLarge),
          ),
          actions: mInOutState.viewMInOut &&
                  mInOutState.mInOut!.docStatus.id.toString() != 'CO'
              ? [
                  IconButton(
                    onPressed: mInOutNotifier.isConfirmMInOut()
                        ? () => mInOutNotifier.confirmMInOut()
                        : () => _showConfirmMInOut(context),
                    icon: Icon(
                      Icons.check,
                      color: mInOutNotifier.isConfirmMInOut()
                          ? themeColorSuccessful
                          : null,
                    ),
                  ),
                ]
              : null,
        ),
        body: TabBarView(
          children: [
            _MInOutView(
                mInOutState: mInOutState,
                mInOutNotifier: mInOutNotifier),
            _ScanView(
                mInOutState: mInOutState,
                mInOutNotifier: mInOutNotifier),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmMInOut(BuildContext context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Confirmar Lineas'),
          content: const Text(
              'Por favor, verifica las líneas. Puede que falten códigos por escanear o que se hayan escaneado de más.'),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Cerrar',
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        );
      },
    );
  }
}

class _MInOutView extends ConsumerWidget {
  final MInOutStatus mInOutState;
  final MInOutNotifier mInOutNotifier;

  const _MInOutView({
    required this.mInOutState,
    required this.mInOutNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMInOutHeader(context, ref),
            const SizedBox(height: 5),
            _buildActionOrderList(mInOutNotifier),
            const SizedBox(height: 5),
            _buildMInOutList(),
            mInOutState.linesOver.isNotEmpty
                ? _buildListOver(
                    context,
                    mInOutState.linesOver,
                    mInOutNotifier,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildMInOutHeader(BuildContext context, WidgetRef ref) {
    return mInOutState.isLoading
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            child: const Center(child: CircularProgressIndicator()),
          )
        : mInOutState.viewMInOut
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(themeBorderRadius),
                        color:
                            mInOutState.mInOut!.docStatus.id.toString() ==
                                    'CO'
                                ? themeColorSuccessfulLight
                                : themeBackgroundColorLight,
                      ),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Doc. No.: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Date: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Order: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'O. Date: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Org.: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Whs.: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'BP: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Status: ',
                                style: const TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                mInOutState.mInOut!.documentNo ?? '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    mInOutState.mInOut!.movementDate),
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                mInOutState.mInOut!.cOrderId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    mInOutState.mInOut!.dateOrdered),
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                mInOutState.mInOut!.adOrgId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                mInOutState
                                        .mInOut!.mWarehouseId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                mInOutState
                                        .mInOut!.cBPartnerId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                mInOutState.mInOut!.docStatus.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: IconButton(
                        icon: Icon(Icons.clear, size: 20),
                        onPressed: mInOutState.scanBarcodeListTotal.isNotEmpty
                            ? () => _showConfirmclearMInOutData(
                                context, mInOutNotifier)
                            : () => mInOutNotifier.clearMInOutData(),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: CustomTextFormField(
                  hint: 'Ingresar documento',
                  onChanged: mInOutNotifier.onDocChange,
                  onFieldSubmitted: (value) =>
                      mInOutNotifier.getMInOutAndLine(ref),
                  prefixIcon: Icon(Icons.qr_code_scanner_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded),
                    color: themeColorPrimary,
                    onPressed: () {
                      mInOutNotifier.getMInOutAndLine(ref);
                    },
                  ),
                ),
              );
  }

  Widget _buildActionOrderList(MInOutNotifier mInOutNotifier) {
    return mInOutState.viewMInOut
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // pendiente
              _buildOrderList(
                icon: Icons.circle_outlined,
                color: themeColorError,
                background: themeColorErrorLight,
                onPressed: () => mInOutNotifier.setOrderBy('pending'),
                name: 'pending',
              ),
              SizedBox(width: 4),
              // menor
              _buildOrderList(
                icon: Icons.radio_button_checked_rounded,
                color: themeColorWarning,
                background: themeColorWarningLight,
                onPressed: () => mInOutNotifier.setOrderBy('minor'),
                name: 'minor',
              ),
              SizedBox(width: 4),
              // correcto
              _buildOrderList(
                icon: Icons.check_circle_outline_rounded,
                color: themeColorSuccessful,
                background: themeColorSuccessfulLight,
                onPressed: () => mInOutNotifier.setOrderBy('correct'),
                name: 'correct',
              ),
              SizedBox(width: 4),
              // supera
              _buildOrderList(
                icon: Icons.warning_amber_rounded,
                color: themeColorWarning,
                background: themeColorWarningLight,
                onPressed: () => mInOutNotifier.setOrderBy('exceeds'),
                name: 'exceeds',
              ),
              SizedBox(width: 4),
              // manual
              _buildOrderList(
                icon: Icons.touch_app_outlined,
                color: themeColorSuccessful,
                background: themeColorSuccessfulLight,
                onPressed: () => mInOutNotifier.setOrderBy('manually'),
                name: 'manually',
              ),
            ],
          )
        : SizedBox();
  }

  Widget _buildOrderList({
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
    required Color background,
    required String name,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(themeBorderRadius),
          color: mInOutState.orderBy == name
              ? background
              : themeBackgroundColorLight,
        ),
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.straight_rounded,
                  size: 18,
                  color:
                      mInOutState.orderBy == name ? color : themeColorGray),
              Icon(icon,
                  size: 18,
                  color:
                      mInOutState.orderBy == name ? color : themeColorGray),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMInOutList() {
    final mInOutLines = mInOutState.mInOut?.lines ?? [];
    return mInOutState.viewMInOut
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: mInOutLines.length,
            itemBuilder: (context, index) {
              final item = mInOutLines[index];
              return GestureDetector(
                onTap: () => _selectLine(context, mInOutNotifier, item),
                child: Column(
                  children: [
                    Divider(height: 0),
                    Container(
                      color: item.verifiedStatus == 'exceeds' ||
                              item.verifiedStatus == 'manually-exceeds'
                          ? themeColorWarningLight
                          : null,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Text(
                              item.line.toString(),
                              style: TextStyle(
                                  fontSize: themeFontSizeSmall,
                                  color: themeColorGray),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      item.upc?.isNotEmpty == true
                                          ? item.upc.toString()
                                          : '',
                                      style: const TextStyle(
                                        fontSize: themeFontSizeLarge,
                                      ),
                                    ),
                                  ),
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  reverse: true,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    child: Text(
                                      item.productName.toString(),
                                      style: TextStyle(
                                        fontSize: themeFontSizeSmall,
                                        color: themeColorGray,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              item.movementQty.toString(),
                              style: const TextStyle(
                                  fontSize: themeFontSizeLarge,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              item.verifiedStatus == 'correct'
                                  ? Icons.check_circle_outline_rounded
                                  : item.verifiedStatus == 'exceeds'
                                      ? Icons.warning_amber_rounded
                                      : item.verifiedStatus ==
                                                  'manually-correct' ||
                                              item.verifiedStatus ==
                                                  'manually-minor' ||
                                              item.verifiedStatus ==
                                                  'manually-exceeds'
                                          ? Icons.touch_app_outlined
                                          : item.verifiedStatus == 'minor'
                                              ? Icons
                                                  .radio_button_checked_rounded
                                              : Icons.circle_outlined,
                              color: item.verifiedStatus == 'correct' ||
                                      item.verifiedStatus == 'manually-correct'
                                  ? themeColorSuccessful
                                  : item.verifiedStatus == 'minor' ||
                                          item.verifiedStatus == 'exceeds' ||
                                          item.verifiedStatus ==
                                              'manually-minor' ||
                                          item.verifiedStatus ==
                                              'manually-exceeds'
                                      ? themeColorWarning
                                      : themeColorError,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Divider(height: 0),
                  ],
                ),
              );
            },
          )
        : SizedBox();
  }

  Future<void> _showConfirmclearMInOutData(
      BuildContext context, MInOutNotifier mInOutNotifier) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Limpiar Shipment'),
          content:
              const Text('¿Estás seguro de que deseas limpiar este Shipment?'),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () {
                mInOutNotifier.clearMInOutData();
                Navigator.of(context).pop();
              },
              label: 'Si',
              icon: const Icon(Icons.check),
              buttonColor: themeColorError,
            ),
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'No',
              icon: const Icon(Icons.close_rounded),
              buttonColor: themeColorGray,
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectLine(
      BuildContext context, MInOutNotifier mInOutNotifier, Line item) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Detalles de la Línea'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Table(
                  columnWidths: {
                    0: IntrinsicColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: item.verifiedStatus == 'manually-correct' ||
                          item.verifiedStatus == 'manually-minor' ||
                          item.verifiedStatus == 'manually-exceeds'
                      ? [
                          _buildTableRow(
                              "UPC:", item.upc?.toString() ?? '', false),
                          _buildTableRow("Producto:",
                              item.productName?.toString() ?? '', false),
                          _buildTableRow("Cantidad:",
                              item.movementQty?.toString() ?? '0', true),
                          _buildTableRow("Escaneado:",
                              item.scanningQty?.toString() ?? '0', true),
                          _buildTableRow("Conf. Manual:",
                              item.manualQty?.toString() ?? '0', true),
                          _buildTableRow("Conf. Manual:",
                              item.verifiedStatus?.toString() ?? '0', true),
                        ]
                      : [
                          _buildTableRow(
                              "UPC:", item.upc?.toString() ?? '', false),
                          _buildTableRow("Producto:",
                              item.productName?.toString() ?? '', false),
                          _buildTableRow("Cantidad:",
                              item.movementQty?.toString() ?? '0', true),
                          _buildTableRow("Escaneado:",
                              item.scanningQty?.toString() ?? '0', true),
                        ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Cerrar',
              icon: const Icon(Icons.close_rounded),
            ),
            item.verifiedStatus == 'manually-correct' ||
                    item.verifiedStatus == 'manually-minor' ||
                    item.verifiedStatus == 'manually-exceeds'
                ? CustomFilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showResetManualLine(context, item);
                    },
                    label: 'Reiniciar',
                    icon: const Icon(Icons.touch_app_outlined),
                    buttonColor: themeColorGray,
                  )
                : CustomFilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      mInOutNotifier.onManualQuantityChange(
                          item.manualQty != null && item.manualQty! > 0
                              ? item.manualQty.toString()
                              : item.movementQty.toString());
                      _showInsertManualLine(context, item);
                    },
                    label: 'Manual',
                    icon: const Icon(Icons.touch_app_outlined),
                    buttonColor: themeColorGray,
                  ),
          ],
        );
      },
    );
  }

  Future<void> _showInsertManualLine(BuildContext context, Line line) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Confirmar Manual'),
          content: CustomTextFormField(
              hint: 'Ingrese la cantidad',
              initialValue: line.manualQty != null && line.manualQty! > 0
                  ? line.manualQty.toString()
                  : line.movementQty.toString(),
              onChanged: mInOutNotifier.onManualQuantityChange,
              onFieldSubmitted: (value) {
                mInOutNotifier.confirmManualLine(line);
                Navigator.of(context).pop();
              }),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () {
                mInOutNotifier.confirmManualLine(line);
                Navigator.of(context).pop();
              },
              label: 'Confirmar',
              icon: const Icon(Icons.check),
            ),
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'Cancelar',
              icon: const Icon(Icons.close_rounded),
              buttonColor: themeColorGray,
            ),
          ],
        );
      },
    );
  }

  Future<void> _showResetManualLine(BuildContext context, Line line) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Reiniciar Manual'),
          content: const Text(
              '¿Estás seguro de que deseas reiniciar la confirmación manual?'),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () {
                mInOutNotifier.resetManualLine(line);
                Navigator.of(context).pop();
              },
              label: 'Si',
              icon: const Icon(Icons.check),
              buttonColor: themeColorError,
            ),
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'No',
              icon: const Icon(Icons.close_rounded),
              buttonColor: themeColorGray,
            ),
          ],
        );
      },
    );
  }

  _buildListOver(BuildContext context, List<Barcode> barcodeList,
      MInOutNotifier mInOutNotifier) {
    return Column(
      children: [
        SizedBox(height: 32),
        Text('Productos a remover',
            style:
                TextStyle(fontSize: themeFontSizeSmall, color: themeColorGray)),
        SizedBox(height: 4),
        Divider(height: 0),
        Column(
          children: barcodeList.map((barcode) {
            return BarcodeList(
              barcode: barcode,
              onPressedDelete: () => _showConfirmDeleteItemOver(
                  context, mInOutNotifier, barcode),
              onPressedrepetitions: () =>
                  mInOutNotifier.selectRepeat(barcode.code),
            );
          }).toList(),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Future<void> _showConfirmDeleteItemOver(BuildContext context,
      MInOutNotifier mInOutNotifier, Barcode barcode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Eliminar Código'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este código de barras?'),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () {
                mInOutNotifier.removeBarcode(barcode: barcode, isOver: true);
                Navigator.of(context).pop();
              },
              label: 'Si',
              icon: const Icon(Icons.check),
              buttonColor: themeColorError,
            ),
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'No',
              icon: const Icon(Icons.close_rounded),
              buttonColor: themeColorGray,
            ),
          ],
        );
      },
    );
  }
}

TableRow _buildTableRow(String label, String value, bool fontSizeTitle) {
  return TableRow(
    children: [
      Container(
        height: fontSizeTitle ? 40 : null,
        padding: const EdgeInsets.fromLTRB(0, 2, 0, 2),
        alignment: fontSizeTitle ? AlignmentDirectional(-1, -0.3) : null,
        child: Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(4, 2, 0, 2),
        child: Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.normal,
            color: themeColorGray,
            fontSize: fontSizeTitle ? themeFontSizeTitle : null,
          ),
        ),
      ),
    ],
  );
}

class _ScanView extends ConsumerWidget {
  final MInOutStatus mInOutState;
  final MInOutNotifier mInOutNotifier;

  const _ScanView({
    required this.mInOutState,
    required this.mInOutNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeList = mInOutState.uniqueView
        ? mInOutState.scanBarcodeListUnique
        : mInOutState.scanBarcodeListTotal;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 4),
          _buildActionFilterList(mInOutNotifier),
          SizedBox(height: 8),
          Divider(height: 0),
          _buildBarcodeList(barcodeList, mInOutNotifier),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EnterBarcodeButton(mInOutNotifier),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFilterList(MInOutNotifier mInOutNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterList(
          text: 'Total',
          counting: mInOutNotifier.getTotalCount().toString(),
          isActive: !mInOutNotifier.getUniqueView(),
          onPressed: () => mInOutNotifier.setUniqueView(false),
        ),
        SizedBox(width: 8),
        _buildFilterList(
          text: 'Únicos',
          counting: mInOutNotifier.getUniqueCount().toString(),
          isActive: mInOutNotifier.getUniqueView(),
          onPressed: () => mInOutNotifier.setUniqueView(true),
        ),
      ],
    );
  }

  Widget _buildFilterList({
    required String text,
    required String counting,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    final styleText = TextStyle(
      fontSize: themeFontSizeSmall,
      fontWeight: FontWeight.bold,
      color: isActive ? themeColorPrimary : themeColorGray,
    );

    final styleCounting = TextStyle(
      fontSize: themeFontSizeLarge,
      fontWeight: FontWeight.bold,
      color: isActive ? themeColorPrimary : themeColorGray,
    );

    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(themeBorderRadius),
          color: isActive ? themeColorPrimaryLight : themeBackgroundColorLight,
        ),
        padding: EdgeInsets.symmetric(vertical: 2, horizontal: 16),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(text, style: styleText),
              SizedBox(width: 8),
              Text(counting, style: styleCounting),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarcodeList(
      List<Barcode> barcodeList, MInOutNotifier mInOutNotifier) {
    return Expanded(
      child: ListView.builder(
        controller: mInOutNotifier.scanBarcodeListScrollController,
        itemCount: barcodeList.length,
        itemBuilder: (BuildContext context, int index) {
          final barcode = barcodeList[index];
          return BarcodeList(
            barcode: barcode,
            onPressedDelete: () =>
                _showConfirmDeleteItem(context, mInOutNotifier, barcode),
            onPressedrepetitions: () =>
                mInOutNotifier.selectRepeat(barcode.code),
          );
        },
      ),
    );
  }

  Future<void> _showConfirmDeleteItem(BuildContext context,
      MInOutNotifier mInOutNotifier, Barcode barcode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: const Text('Eliminar Código'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este código de barras?'),
          actions: <Widget>[
            CustomFilledButton(
              onPressed: () {
                mInOutNotifier.removeBarcode(barcode: barcode);
                Navigator.of(context).pop();
              },
              label: 'Si',
              icon: const Icon(Icons.check),
              buttonColor: themeColorError,
            ),
            CustomFilledButton(
              onPressed: () => Navigator.of(context).pop(),
              label: 'No',
              icon: const Icon(Icons.close_rounded),
              buttonColor: themeColorGray,
            ),
          ],
        );
      },
    );
  }
}
