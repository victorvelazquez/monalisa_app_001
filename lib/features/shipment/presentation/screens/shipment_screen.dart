import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/barcode_list.dart';
import 'package:monalisa_app_001/features/shipment/presentation/widgets/enter_barcode_box.dart';
import '../../domain/entities/barcode.dart';
import '../providers/barcode_list_providers.dart';

class ShipmentScreen extends StatelessWidget {
  const ShipmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        body: const TabBarView(
          children: [
            _ShipmentView(),
            _VerifyView(),
            _ScanView(),
          ],
        ),
      ),
    );
  }
}

class _ShipmentView extends ConsumerWidget {
  const _ShipmentView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
      child: Center(child: Text('Shipment View Content')),
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
  const _ScanView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barcodeListState = ref.watch(barcodeListProvider);
    final barcodeListNotifier = ref.read(barcodeListProvider.notifier);
    final barcodeList = barcodeListState.uniqueView
        ? barcodeListState.barcodeListUnique
        : barcodeListState.barcodeListTotal;

    return SafeArea(
      child: Container(
        color: backgroundColor,
        child: Column(
          children: [
            _buildActionFilterList(barcodeListNotifier),
            _buildBarcodeList(barcodeList, barcodeListNotifier),
            EnterBarcodeBox(onValue: barcodeListNotifier.addBarcode),
          ],
        ),
      ),
    );
  }

  Widget _buildActionFilterList(BarcodeListNotifier barcodeListNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildFilterList(
          text: 'Total',
          counting: barcodeListNotifier.getTotalCount().toString(),
          isActive: !barcodeListNotifier.getUniqueView(),
          onPressed: () => barcodeListNotifier.setUniqueView(false),
        ),
        _buildFilterList(
          text: 'Únicos',
          counting: barcodeListNotifier.getUniqueCount().toString(),
          isActive: barcodeListNotifier.getUniqueView(),
          onPressed: () => barcodeListNotifier.setUniqueView(true),
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
      List<Barcode> barcodeList, BarcodeListNotifier barcodeListNotifier) {
    return Expanded(
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
              return BarcodeList(
                barcode: barcode,
                onPressedDelete: () => _showConfirmDeleteItem(
                    context, barcodeListNotifier, barcode),
                onPressedrepetitions: () => barcodeListNotifier.selectRepeat(barcode.code),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _showConfirmDeleteItem(BuildContext context,
      BarcodeListNotifier barcodeListNotifier, Barcode barcode) {
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
                barcodeListNotifier.removeBarcode(barcode);
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
