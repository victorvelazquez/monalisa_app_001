import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/barcode_list.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/enter_barcode_box.dart';

import '../providers/barcode_list_providers.dart';

class ShipmentScreen extends StatelessWidget {
  const ShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Shipment'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Shipment'),
              Tab(text: 'Verify'),
              Tab(text: 'Line'),
            ],
            labelColor: colorSeed,
            labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontSize: 14),
            indicatorWeight: 4,
            indicatorColor: colorSeed,
          ),
        ),
        body: TabBarView(
          physics:
              const NeverScrollableScrollPhysics(), // Evitar que las pestañas sean desplazables
          children: [
            _ShipmentView(),
            _VeriFyView(),
            _LineView(),
          ],
        ),
      ),
    );
  }
}

class _ShipmentView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}

class _LineView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeList = ref.watch(barcodeListProvider);
    final barcodeListNotifier = ref.read(barcodeListProvider.notifier);
    // final colors = Theme.of(context).colorScheme;
    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: colorSeed,
                    side: BorderSide(color: colorSeed, width: 1),
                  ),
                  child: Text('Total: ${barcodeListNotifier.totalCodes}'),
                ),
                OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: colorSeed,
                      backgroundColor: Colors.white,
                      side: BorderSide(color: colorSeed, width: 1),
                    ),
                    child: Text('Únicos: ${barcodeListNotifier.uniqueCodes}')),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    controller: barcodeListNotifier.barcodeListScrollController,
                    itemCount: barcodeList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final barcode = barcodeList[index];
                      return Column(
                        children: [
                          BarcodeList(
                            barcode: barcode,
                            onPressed: () => barcodeListNotifier.removeBarcodeByIndex(barcodeList[index].index),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            EnterBarcodeBox(
              // onValue: (value) => barcodeListNotifier.addBarcode(value),
              onValue: barcodeListNotifier.addBarcode,
            ),
          ],
        ),
      ),
    );
  }
}

class _VeriFyView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }
}
