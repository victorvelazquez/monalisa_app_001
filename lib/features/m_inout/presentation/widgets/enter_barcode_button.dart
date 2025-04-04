import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/storage_on_hand.dart';
import 'package:monalisa_app_001/features/m_inout/presentation/providers/m_in_out_providers.dart';

import '../../../shared/shared.dart';
import '../../domain/entities/product.dart';

class EnterBarcodeButton extends StatefulWidget {
  final MInOutNotifier mInOutNotifier;
  final MInOutStatus mInOutState;
  final WidgetRef ref;
  const EnterBarcodeButton(this.mInOutNotifier, this.mInOutState, this.ref,
      {super.key});

  @override
  EnterBarcodeButtonState createState() => EnterBarcodeButtonState();
}

class EnterBarcodeButtonState extends State<EnterBarcodeButton> {
  final FocusNode _focusNode = FocusNode();
  String scannedData = "";
  Product? product;
  List<StorageOnHand> storageOnHands = [];
  StorageOnHand? selectedStorageOnHand;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _handleKeyEvent(KeyEvent event, WidgetRef ref) {
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      addBarcode(ref);
      return;
    }

    if (event.character != null && event.character!.isNotEmpty) {
      setState(() {
        scannedData += event.character!;
      });
    }

    // print(event.toString());
    // setState(() {
    //   scannedData =
    //       'deviceType:${event.deviceType.toString()}|logicalKey:${event.logicalKey.toString()}|physicalKey:${event.physicalKey.toString()}|character:${event.character}';
    // });
    // addBarcode();
  }

  void addBarcode(WidgetRef ref) async {
    if (scannedData.isNotEmpty) {
      if (widget.mInOutState.createNewInventoryMove) {
        setState(() {
          loading = true;
        });
        product = await widget.mInOutNotifier.getProductByUPC(scannedData, ref);
        if (product?.id != null) {
          storageOnHands =
              await widget.mInOutNotifier.getStorageOnHand(product!.id!, ref);
          if (storageOnHands.isNotEmpty && mounted) {
            _showSelectStorageOnHand(product!, storageOnHands, context, ref);
          }
        }
        setState(() {
          loading = false;
        });
      } else {
        widget.mInOutNotifier.addBarcode(scannedData);
      }

      setState(() {
        scannedData = "";
      });
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) => _handleKeyEvent(event, widget.ref),
      child: GestureDetector(
        onTap: () {
          if (!loading) {
            addBarcode(widget.ref);
            _focusNode.requestFocus();
          }
        },
        child: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _focusNode.hasFocus && !loading
                ? themeColorPrimary
                : Colors.grey,
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              loading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : Icon(Icons.barcode_reader, color: Colors.white),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  loading
                      ? 'Cargando...'
                      : _focusNode.hasFocus
                          ? scannedData.isNotEmpty
                              ? scannedData
                              : 'Listo para escanear'
                          : 'Presiona para escanear',
                  style: TextStyle(
                      color: Colors.white, fontSize: themeFontSizeLarge),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSelectStorageOnHand(Product product,
      List<StorageOnHand> storageOnHands, BuildContext context, WidgetRef ref) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          title: Text('Producto disponible'),
          content: storageOnHands.isNotEmpty
              ? Column(
                  children: [
                    Text(product.name ?? ''),
                    SizedBox(height: 16),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: storageOnHands.length,
                        itemBuilder: (context, index) {
                          final item = storageOnHands[index];
                          return GestureDetector(
                            onTap: () {
                              // funcion para agregar el producto
                              Navigator.of(context).pop();
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Divider(height: 0),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 8),
                                  child: Row(
                                    children: [
                                      Text(
                                        item.qtyOnHand.toString(),
                                        style: const TextStyle(
                                          fontSize: themeFontSizeLarge,
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8),
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Text(
                                              '-> ${item.locator?.identifier}',
                                              style: TextStyle(
                                                fontSize: themeFontSizeLarge,
                                                color: themeColorGray,
                                              ),
                                              overflow: TextOverflow.fade,
                                              softWrap: false,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(height: 0),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                )
              : Text('Stock no disponible para el producto.'),
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
