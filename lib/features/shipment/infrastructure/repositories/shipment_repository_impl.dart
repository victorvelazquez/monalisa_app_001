import 'package:monalisa_app_001/features/shipment/domain/entities/shipment.dart';
import 'package:monalisa_app_001/features/shipment/domain/repositories/shipment_repositiry.dart';

import '../../domain/datasources/shipment_datasource.dart';
import '../datasources/shipment_datasource_impl.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentDataSource dataSource;

  ShipmentRepositoryImpl({ShipmentDataSource? dataSource})
      : dataSource = dataSource ?? ShipmentDataSourceImpl();
  
  @override
  Future<Shipment> getShipmentAndLine(String shipment) {
    return dataSource.getShipmentAndLine(shipment);
  }
}