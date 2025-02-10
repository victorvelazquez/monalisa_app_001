import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shared/shared.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/line.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/barcode_list.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/barcode.dart';
import '../providers/shipment_providers.dart';
import '../widgets/enter_barcode_button.dart';

class ShipmentScreen extends ConsumerWidget {
  const ShipmentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shipmentState = ref.watch(shipmentProvider);
    final shipmentNotifier = ref.read(shipmentProvider.notifier);

    ref.listen(shipmentProvider, (previous, next) {
      if (next.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(next.errorMessage)));
      }
    });

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: 'Shipment'),
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
          actions: shipmentState.viewShipment &&
                  shipmentState.shipment!.docStatus.id.toString() != 'CO'
              ? [
                  IconButton(
                    onPressed: shipmentNotifier.isConfirmShipment()
                        ? () => shipmentNotifier.confirmShipment()
                        : () => _showConfirmShipment(context),
                    icon: Icon(
                      Icons.check,
                      color: shipmentNotifier.isConfirmShipment()
                          ? themeColorSuccessful
                          : null,
                    ),
                  ),
                ]
              : null,
        ),
        body: TabBarView(
          children: [
            _ShipmentView(
                shipmentState: shipmentState,
                shipmentNotifier: shipmentNotifier),
            _ScanView(
                shipmentState: shipmentState,
                shipmentNotifier: shipmentNotifier),
          ],
        ),
      ),
    );
  }

  Future<void> _showConfirmShipment(BuildContext context) {
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

class _ShipmentView extends ConsumerWidget {
  final ShipmentStatus shipmentState;
  final ShipmentNotifier shipmentNotifier;

  const _ShipmentView({
    required this.shipmentState,
    required this.shipmentNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildShipmentHeader(context, ref),
            const SizedBox(height: 5),
            _buildActionOrderList(shipmentNotifier),
            const SizedBox(height: 5),
            _buildShipmentList(),
            shipmentState.linesOver.isNotEmpty
                ? _buildListOver(
                    context,
                    shipmentState.linesOver,
                    shipmentNotifier,
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildShipmentHeader(BuildContext context, WidgetRef ref) {
    return shipmentState.isLoading
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            child: const Center(child: CircularProgressIndicator()),
          )
        : shipmentState.viewShipment
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
                            shipmentState.shipment!.docStatus.id.toString() ==
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
                                shipmentState.shipment!.documentNo ?? '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    shipmentState.shipment!.movementDate),
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                shipmentState.shipment!.cOrderId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                DateFormat('dd/MM/yyyy').format(
                                    shipmentState.shipment!.dateOrdered),
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                shipmentState.shipment!.adOrgId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                shipmentState
                                        .shipment!.mWarehouseId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                shipmentState
                                        .shipment!.cBPartnerId.identifier ??
                                    '',
                                style: TextStyle(fontSize: themeFontSizeSmall),
                              ),
                              Text(
                                shipmentState.shipment!.docStatus.identifier ??
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
                        onPressed: shipmentState.scanBarcodeListTotal.isNotEmpty
                            ? () => _showConfirmclearShipmentData(
                                context, shipmentNotifier)
                            : () => shipmentNotifier.clearShipmentData(),
                      ),
                    ),
                  ],
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: CustomTextFormField(
                  hint: 'Ingresar documento',
                  onChanged: shipmentNotifier.onDocChange,
                  onFieldSubmitted: (value) =>
                      shipmentNotifier.getShipmentAndLine(ref),
                  prefixIcon: Icon(Icons.qr_code_scanner_rounded),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.send_rounded),
                    color: themeColorPrimary,
                    onPressed: () {
                      shipmentNotifier.getShipmentAndLine(ref);
                    },
                  ),
                ),
              );
  }

  Widget _buildActionOrderList(ShipmentNotifier shipmentNotifier) {
    return shipmentState.viewShipment
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // pendiente
              _buildOrderList(
                icon: Icons.circle_outlined,
                color: themeColorError,
                background: themeColorErrorLight,
                onPressed: () => shipmentNotifier.setOrderBy('pending'),
                name: 'pending',
              ),
              SizedBox(width: 4),
              // menor
              _buildOrderList(
                icon: Icons.circle_outlined,
                color: themeColorWarning,
                background: themeColorWarningLight,
                onPressed: () => shipmentNotifier.setOrderBy('minor'),
                name: 'minor',
              ),
              SizedBox(width: 4),
              // supera
              _buildOrderList(
                icon: Icons.warning_amber_rounded,
                color: themeColorWarning,
                background: themeColorWarningLight,
                onPressed: () => shipmentNotifier.setOrderBy('exceeds'),
                name: 'exceeds',
              ),
              SizedBox(width: 4),
              // manual
              _buildOrderList(
                icon: Icons.touch_app_outlined,
                color: themeColorSuccessful,
                background: themeColorSuccessfulLight,
                onPressed: () => shipmentNotifier.setOrderBy('manually'),
                name: 'manually',
              ),
              SizedBox(width: 4),
              // correcto
              _buildOrderList(
                icon: Icons.check_circle_outline_rounded,
                color: themeColorSuccessful,
                background: themeColorSuccessfulLight,
                onPressed: () => shipmentNotifier.setOrderBy('correct'),
                name: 'correct',
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
          color: shipmentState.orderBy == name
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
                      shipmentState.orderBy == name ? color : themeColorGray),
              Icon(icon,
                  size: 18,
                  color:
                      shipmentState.orderBy == name ? color : themeColorGray),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShipmentList() {
    final shipmentLines = shipmentState.shipment?.lines ?? [];
    return shipmentState.viewShipment
        ? ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: shipmentLines.length,
            itemBuilder: (context, index) {
              final item = shipmentLines[index];
              return GestureDetector(
                onTap: () => _selectLine(context, shipmentNotifier, item),
                child: Column(
                  children: [
                    Divider(height: 0),
                    Container(
                      color: item.verifiedStatus == 'exceeds'
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
                                      : item.verifiedStatus == 'manually'
                                          ? Icons.touch_app_outlined
                                          : Icons.circle_outlined,
                              color: item.verifiedStatus == 'correct' ||
                                      item.verifiedStatus == 'manually'
                                  ? themeColorSuccessful
                                  : item.verifiedStatus == 'minor' ||
                                          item.verifiedStatus == 'exceeds'
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

  Future<void> _showConfirmclearShipmentData(
      BuildContext context, ShipmentNotifier shipmentNotifier) {
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
                shipmentNotifier.clearShipmentData();
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
      BuildContext context, ShipmentNotifier shipmentNotifier, Line item) {
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
                  children: [
                    _buildTableRow("UPC:", item.upc?.toString() ?? '', false),
                    _buildTableRow(
                        "Producto:", item.productName?.toString() ?? '', false),
                    _buildTableRow(
                        "Cantidad:", item.movementQty?.toString() ?? '0', true),
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
            CustomFilledButton(
              onPressed: () {
                shipmentNotifier.confirmManualLine(item);
                Navigator.of(context).pop();
              },
              label: 'Manual',
              icon: const Icon(Icons.touch_app_outlined),
              buttonColor: themeColorGrayLight,
            ),
          ],
        );
      },
    );
  }

  _buildListOver(BuildContext context, List<Barcode> barcodeList,
      ShipmentNotifier shipmentNotifier) {
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
                  context, shipmentNotifier, barcode),
              onPressedrepetitions: () =>
                  shipmentNotifier.selectRepeat(barcode.code),
            );
          }).toList(),
        ),
        SizedBox(height: 4),
      ],
    );
  }

  Future<void> _showConfirmDeleteItemOver(BuildContext context,
      ShipmentNotifier shipmentNotifier, Barcode barcode) {
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
                shipmentNotifier.removeBarcode(barcode: barcode, isOver: true);
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
  final ShipmentStatus shipmentState;
  final ShipmentNotifier shipmentNotifier;

  const _ScanView({
    required this.shipmentState,
    required this.shipmentNotifier,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeList = shipmentState.uniqueView
        ? shipmentState.scanBarcodeListUnique
        : shipmentState.scanBarcodeListTotal;

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 4),
          _buildActionFilterList(shipmentNotifier),
          SizedBox(height: 8),
          Divider(height: 0),
          _buildBarcodeList(barcodeList, shipmentNotifier),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: EnterBarcodeButton(shipmentNotifier),
          ),
        ],
      ),
    );
  }

  Widget _buildActionFilterList(ShipmentNotifier shipmentNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildFilterList(
          text: 'Total',
          counting: shipmentNotifier.getTotalCount().toString(),
          isActive: !shipmentNotifier.getUniqueView(),
          onPressed: () => shipmentNotifier.setUniqueView(false),
        ),
        SizedBox(width: 8),
        _buildFilterList(
          text: 'Únicos',
          counting: shipmentNotifier.getUniqueCount().toString(),
          isActive: shipmentNotifier.getUniqueView(),
          onPressed: () => shipmentNotifier.setUniqueView(true),
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
      List<Barcode> barcodeList, ShipmentNotifier shipmentNotifier) {
    return Expanded(
      child: ListView.builder(
        controller: shipmentNotifier.scanBarcodeListScrollController,
        itemCount: barcodeList.length,
        itemBuilder: (BuildContext context, int index) {
          final barcode = barcodeList[index];
          return BarcodeList(
            barcode: barcode,
            onPressedDelete: () =>
                _showConfirmDeleteItem(context, shipmentNotifier, barcode),
            onPressedrepetitions: () =>
                shipmentNotifier.selectRepeat(barcode.code),
          );
        },
      ),
    );
  }

  Future<void> _showConfirmDeleteItem(BuildContext context,
      ShipmentNotifier shipmentNotifier, Barcode barcode) {
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
                shipmentNotifier.removeBarcode(barcode: barcode);
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
