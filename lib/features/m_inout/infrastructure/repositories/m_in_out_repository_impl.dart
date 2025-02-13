import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/repositories/m_in_out_repositiry.dart';

import '../../domain/datasources/m_inout_datasource.dart';
import '../datasources/m_in_out_datasource_impl.dart';

class MInOutRepositoryImpl implements MInOutRepository {
  final MInOutDataSource dataSource;

  MInOutRepositoryImpl({MInOutDataSource? dataSource})
      : dataSource = dataSource ?? MInOutDataSourceImpl();
  
  @override
  Future<MInOut> getMInOutAndLine(String mInOut, bool isSOTrx, WidgetRef ref) {
    return dataSource.getMInOutAndLine(mInOut, isSOTrx, ref);
  }
}