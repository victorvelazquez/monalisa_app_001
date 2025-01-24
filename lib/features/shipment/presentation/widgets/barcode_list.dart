import 'package:flutter/material.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/barcode.dart';

class BarcodeList extends StatefulWidget {
  final Barcode barcode;
  final VoidCallback onPressedrepetitions;
  final VoidCallback onPressedDelete;
  const BarcodeList({
    super.key,
    required this.barcode,
    required this.onPressedrepetitions,
    required this.onPressedDelete,
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
        Container(
          color: widget.barcode.coloring ? const Color.fromRGBO(20, 25, 45, 0.5) : null,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  widget.barcode.index.toString(),
                  style: TextStyle(fontSize: 18, color: Colors.grey[700]),
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
              IconButton(
                onPressed:  widget.onPressedrepetitions,
                icon: Text(
                  widget.barcode.repetitions.toString(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: widget.onPressedDelete,
                icon: const Icon(Icons.clear_rounded),
                color: Colors.redAccent,
              ),
            ],
          ),
        ),
        Divider(height: 0),
      ],
    );
  }
}
