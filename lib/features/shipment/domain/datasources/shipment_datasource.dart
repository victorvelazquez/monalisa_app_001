import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/shipment/domain/entities/shipment.dart';

abstract class ShipmentDataSource {
  Future<Shipment> getShipmentAndLine(String shipment, WidgetRef ref);
}
