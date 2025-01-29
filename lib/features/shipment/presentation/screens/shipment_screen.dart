import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
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
          title: const TabBar(
            tabs: [
              Tab(text: 'Shipment'),
              Tab(text: 'Scan'),
            ],
            isScrollable: true,
            indicatorWeight: 4,
            indicatorColor: colorSeed,
            dividerColor: colorSeed,
            tabAlignment: TabAlignment.start,
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14),
          ),
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
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShipmentHeader(),
                    const SizedBox(height: 10),
                    _buildShipmentList(),
                  ],
                ),
                shipmentState.viewShipment ? Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: Icon(Icons.clear, size: 20),
                    onPressed: () {
                      shipmentNotifier.clearShipmentData();
                    },
                  ),
                ) : SizedBox(),
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
    return Container(
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
          return Column(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Text(
                              item.upc?.isNotEmpty == true
                                  ? item.upc.toString()
                                  : '',
                              style: const TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      item.movementQty.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      item.verifiedStatus == 'correct'
                          ? Icons.check_circle_outline_rounded
                          : item.verifiedStatus == 'over'
                              ? Icons.warning_amber_rounded
                              : item.verifiedStatus == 'manually'
                                  ? Icons.touch_app_outlined
                                  : Icons.circle_outlined,
                      color: item.verifiedStatus == 'correct' ||
                              item.verifiedStatus == 'manually'
                          ? Colors.green[600]
                          : item.verifiedStatus == 'over'
                              ? Colors.yellow[800]
                              : Colors.red[600],
                    ),
                  ),
                ],
              ),
              Divider(height: 0),
            ],
          );
        },
      ),
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
        color: backgroundColor,
        child: Column(
          children: [
            _buildActionFilterList(shipmentNotifier),
            _buildBarcodeList(barcodeList, shipmentNotifier),
            SizedBox(height: 10),
            EnterBarcodeBox(
                onValue: shipmentNotifier.addBarcode,
                hintText: 'Escanear código de barras'),
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
      fontSize: 18,
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

    // return Expanded(
    //   child: TextButton(
    //     onPressed: onPressed,
    //     style: TextButton.styleFrom(
    //       padding: EdgeInsets.zero,
    //       minimumSize: const Size(0, 0),
    //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    //     ),
    //     child: Column(
    //       children: [
    //         Text(text, style: styleText),
    //         Text(counting, style: styleCounting),
    //       ],
    //     ),
    //   ),
    // );
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
          title: const Text('Confirmación'),
          content: const Text(
              '¿Estás seguro de que deseas eliminar este código de barras?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
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
          ],
        );
      },
    );
  }
}
