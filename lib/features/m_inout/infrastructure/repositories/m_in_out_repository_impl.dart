import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/repositories/m_in_out_repositiry.dart';

import '../../domain/datasources/m_inout_datasource.dart';
import '../../domain/entities/m_in_out_confirm.dart';
import '../datasources/m_in_out_datasource_impl.dart';

class MInOutRepositoryImpl implements MInOutRepository {
  final MInOutDataSource dataSource;

  MInOutRepositoryImpl({MInOutDataSource? dataSource})
      : dataSource = dataSource ?? MInOutDataSourceImpl();

  @override
  Future<List<MInOut>> getMInOutList(bool isSOTrx, WidgetRef ref) {
    return dataSource.getMInOutList(isSOTrx, ref);
  }

  @override
  Future<List<MInOutConfirm>> getMInOutConfirmList(int mInOutId, bool isSOTrx, WidgetRef ref) {
    return dataSource.getMInOutConfirmList(mInOutId, isSOTrx, ref);
  }

  @override
  Future<MInOut> getMInOutAndLine(String mInOut, bool isSOTrx, WidgetRef ref) {
    return dataSource.getMInOutAndLine(mInOut, isSOTrx, ref);
  }

  @override
  Future<MInOut> setDocAction(MInOut mInOut, bool isSOTrx, WidgetRef ref) {
    return dataSource.setDocAction(mInOut, isSOTrx, ref);
  }
}