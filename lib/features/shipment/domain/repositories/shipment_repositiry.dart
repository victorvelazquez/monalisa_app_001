import '../entities/shipment.dart';

abstract class ShipmentRepository {
  Future<Shipment> getShipmentAndLine(String shipment);
}
