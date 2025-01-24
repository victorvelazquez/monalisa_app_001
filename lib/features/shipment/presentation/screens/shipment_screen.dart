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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const TabBar(
            tabs: [
              Tab(text: 'Shipment'),
              Tab(text: 'Confirm'),
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
            _VerifyView(),
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
    final shipmentHeader = {
      "DocumentNo": "MOWHS-00502096",
      "MovementDate": "2025-01-16",
      "Order": "51965_01/14/2025",
      "DateOrdered": "2025-01-14",
      "Organization": "MOWHS MONALISA SRL",
      "Warehouse": "MOWHS",
      "Business Partner": "EMAP S.A.",
    };

    final shipmentItems = [
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
      {
        "SKU": "TZD32833",
        "UPC": "0085715328335",
        "ProductName": "GUESS UOMO EDT 100ML TST",
        "MovementQty": 1,
      },
    ];

    return SafeArea(
      child: Container(
        color: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShipmentHeader(shipmentHeader),
                const SizedBox(height: 10),
                _buildShipmentList(shipmentItems),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildShipmentHeader(Map<String, String> shipmentHeader) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: shipmentHeader.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: RichText(
              text: TextSpan(
                text: '${entry.key}:  ',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                children: [
                  TextSpan(
                    text: entry.value,
                    style: TextStyle(
                        fontWeight: FontWeight.normal, color: Colors.grey[700]),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
    // return EnterBarcodeBox(
    //     onValue: shipmentNotifier.getShipmentAndLine,
    //     hintText: 'Ingresar documento');
  }

  Widget _buildShipmentList(List<Map<String, Object>> shipmentItems) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: shipmentItems.length,
        itemBuilder: (context, index) {
          final item = shipmentItems[index];
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
                          child: Text(
                            item['UPC'].toString(),
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            item['ProductName'].toString(),
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      item['MovementQty'].toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                      index % 2 == 0 ? Icons.check : Icons.close,
                      color:
                          index % 2 == 0 ? Colors.green[600] : Colors.red[600],
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

class _VerifyView extends StatelessWidget {
  const _VerifyView();

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Center(child: Text('Verify View Content')),
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
        padding: EdgeInsets.all(10),
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
      fontSize: 10,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      color: isActive ? Colors.black : Colors.grey[600],
    );

    final styleCounting = TextStyle(
      fontSize: 18,
      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
      color: isActive ? Colors.black : Colors.grey[600],
    );

    return Expanded(
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 0),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Column(
          children: [
            Text(text, style: styleText),
            Text(counting, style: styleCounting),
          ],
        ),
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
