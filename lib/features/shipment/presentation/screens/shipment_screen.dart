import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/line.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/barcode_list.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/enter_barcode_box.dart';
import '../../domain/entities/barcode.dart';
import '../providers/shipment_providers.dart';

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
            indicatorColor: colorSeed,
            dividerColor: colorSeed,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: colorSeed),
            unselectedLabelStyle: TextStyle(fontSize: 16),
          ),
          actions: shipmentState.viewShipment
              ? [
                  IconButton(
                    onPressed: shipmentNotifier.isConfirmShipment()
                        ? () => shipmentNotifier.confirmShipment()
                        : () => _showConfirmShipment(context, shipmentNotifier),
                    icon: Icon(
                      Icons.check,
                      color: shipmentNotifier.isConfirmShipment()
                          ? Colors.green[600]
                          : Colors.grey[800],
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

  Future<void> _showConfirmShipment(
      BuildContext context, ShipmentNotifier shipmentNotifier) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Lineas'),
          content: const Text(
              'Por favor, verifica las líneas. Puede que falten códigos por escanear o que se hayan escaneado de más.'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
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
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShipmentHeader(),
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
                shipmentState.viewShipment
                    ? Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: Icon(Icons.clear, size: 20),
                          onPressed:
                              shipmentState.scanBarcodeListTotal.isNotEmpty
                                  ? () => _showConfirmclearShipmentData(
                                      context, shipmentNotifier)
                                  : () => shipmentNotifier.clearShipmentData(),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShipmentHeader() {
    return shipmentState.isLoading
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.all(30),
            child: const Center(child: CircularProgressIndicator()),
          )
        : shipmentState.viewShipment
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'Doc. No.: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: shipmentState.shipment!.documentNo,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Movement Date: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                shipmentState.shipment!.movementDate.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Order: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: shipmentState.shipment!.cOrderId.identifier,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Order Date: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                shipmentState.shipment!.dateOrdered.toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Organization: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text: shipmentState.shipment!.adOrgId.identifier,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Warehouse: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                shipmentState.shipment!.mWarehouseId.identifier,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Business Partner: ',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        children: [
                          TextSpan(
                            text:
                                shipmentState.shipment!.cBPartnerId.identifier,
                            style: TextStyle(
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : EnterBarcodeBox(
                onValue: shipmentNotifier.getShipmentAndLine,
                hintText: 'Ingresar documento');
  }

  Widget _buildShipmentList() {
    final shipmentLines = shipmentState.shipment?.lines ?? [];
    return shipmentState.viewShipment
        ? Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: shipmentLines.length,
              itemBuilder: (context, index) {
                final item = shipmentLines[index];
                return GestureDetector(
                  onTap: () => _selectLine(context, shipmentNotifier, item),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                            child: Text(
                              (index + 1).toString(),
                              style: TextStyle(
                                  fontSize: 16, color: Colors.grey[700]),
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    child: Text(
                                      item.upc?.isNotEmpty == true
                                          ? item.upc.toString()
                                          : '',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    reverse: true,
                                    child: Text(
                                      item.productName.toString(),
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[700],
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
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              item.verifiedStatus == 'correct'
                                  ? Icons.check_circle_outline_rounded
                                  : item.verifiedStatus == 'different'
                                      ? Icons.warning_amber_rounded
                                      : item.verifiedStatus == 'manually'
                                          ? Icons.touch_app_outlined
                                          : Icons.circle_outlined,
                              color: item.verifiedStatus == 'correct' ||
                                      item.verifiedStatus == 'manually'
                                  ? Colors.green[600]
                                  : item.verifiedStatus == 'different'
                                      ? Colors.yellow[800]
                                      : Colors.red[600],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 0),
                    ],
                  ),
                );
              },
            ),
          )
        : SizedBox();
  }

  Future<void> _showConfirmclearShipmentData(
      BuildContext context, ShipmentNotifier shipmentNotifier) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Limpiar Shipment'),
          content:
              const Text('¿Estás seguro de que deseas limpiar este Shipment?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                shipmentNotifier.clearShipmentData();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Limpiar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
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
          title: const Text('Detalles de la Línea'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  text: 'UPC: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: item.upc,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Producto: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: item.productName,
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Cantidad: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: item.movementQty.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Escaneado: ',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                  children: [
                    TextSpan(
                      text: item.scanningQty.toString(),
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[800]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                shipmentNotifier.confirmManualLine(item);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Confirmar Manual',
                style: TextStyle(color: Colors.green),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
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
        SizedBox(height: 16),
        Text('Códigos Escaneados de más', style: TextStyle(fontSize: 16)),
        SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
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
        ),
        SizedBox(height: 5),
      ],
    );
  }

  Future<void> _showConfirmDeleteItemOver(BuildContext context,
      ShipmentNotifier shipmentNotifier, Barcode barcode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Código'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este código de barras?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                shipmentNotifier.removeBarcode(barcode);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        color: backgroundColor,
        child: Column(
          children: [
            _buildActionFilterList(shipmentNotifier),
            _buildBarcodeList(barcodeList, shipmentNotifier),
            SizedBox(height: 5),
            EnterBarcodeBox(
                onValue: shipmentNotifier.addBarcode,
                hintText: 'Escanear código de barras'),
            SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFilterList(ShipmentNotifier shipmentNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterList(
          text: 'Total',
          counting: shipmentNotifier.getTotalCount().toString(),
          isActive: !shipmentNotifier.getUniqueView(),
          onPressed: () => shipmentNotifier.setUniqueView(false),
        ),
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
      fontSize: 12,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      color: isActive ? Colors.white : Colors.grey[700],
    );

    final styleCounting = TextStyle(
      fontSize: 16,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      color: isActive ? Colors.white : Colors.grey[700],
    );

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(130, 30),
        backgroundColor: isActive ? colorSeedLight : Colors.white,
        side: BorderSide(
          color: isActive ? colorSeedLight : Colors.grey[700]!,
        ),
      ),
      child: Row(
        children: [
          Text(text, style: styleText),
          SizedBox(width: 10),
          Text(counting, style: styleCounting),
        ],
      ),
    );
  }

  Widget _buildBarcodeList(
      List<Barcode> barcodeList, ShipmentNotifier shipmentNotifier) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
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
      ),
    );
  }

  Future<void> _showConfirmDeleteItem(BuildContext context,
      ShipmentNotifier shipmentNotifier, Barcode barcode) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Código'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este código de barras?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                shipmentNotifier.removeBarcode(barcode);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Eliminar',
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
  }
}
