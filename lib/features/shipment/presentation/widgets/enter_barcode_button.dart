import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monalisa_app_001/config/config.dart';
import 'package:monalisa_app_001/features/shipment/presentation/providers/shipment_providers.dart';

class EnterBarcodeButton extends StatefulWidget {
  final ShipmentNotifier shipmentNotifier;
  const EnterBarcodeButton(this.shipmentNotifier, {super.key});

  @override
  EnterBarcodeButtonState createState() => EnterBarcodeButtonState();
}

class EnterBarcodeButtonState extends State<EnterBarcodeButton> {
  final FocusNode _focusNode = FocusNode();
  String scannedData = "";

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

  void _handleKeyEvent(KeyEvent event) {
    Future.delayed(Duration(milliseconds: 100), () {
      if (event is KeyDownEvent) {
        if (event.logicalKey == LogicalKeyboardKey.enter) {
          widget.shipmentNotifier.addBarcode(scannedData);
          setState(() {
            scannedData = "";
          });
        } else {
          setState(() {
            scannedData += event.logicalKey.keyLabel;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: _handleKeyEvent,
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Container(
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
            color: _focusNode.hasFocus ? themeColorPrimary : Colors.grey,
            borderRadius: BorderRadius.circular(themeBorderRadius),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.barcode_reader, color: Colors.white),
              SizedBox(width: 10),
              Flexible(
                child: Text(
                  _focusNode.hasFocus
                      ? scannedData.isNotEmpty
                          ? scannedData
                          : 'Listo para escanear'
                      : 'Presiona para escanear',
                  style: TextStyle(color: Colors.white, fontSize: themeFontSizeLarge),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
