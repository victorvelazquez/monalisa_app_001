import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/shipment.dart';

abstract class ShipmentRepository {
  Future<Shipment> getShipmentAndLine(String shipment, WidgetRef ref);
}
