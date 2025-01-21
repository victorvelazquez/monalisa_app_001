import 'package:flutter/material.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/barcode.dart';

class BarcodeList extends StatefulWidget {
  final Barcode barcode;
  final VoidCallback onPressed;
  const BarcodeList({
    super.key,
    required this.barcode,
    required this.onPressed,
  });

  @override
  ScrollingTextWidgetState createState() => ScrollingTextWidgetState();
}

class ScrollingTextWidgetState extends State<BarcodeList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Mueve el scroll al final cuando el widget se inicializa
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.barcode.index.toString(),
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ),
            Expanded(
                child: SingleChildScrollView(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              child: Text(
                widget.barcode.code.toString(),
                style: TextStyle(fontSize: 18),
              ),
            )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                widget.barcode.repetitions.toString(),
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              onPressed: widget.onPressed,
              icon: const Icon(Icons.clear_rounded),
              color: Colors.redAccent,
            ),
          ],
        ),
        Divider(height: 8),
      ],
    );
  }
}
