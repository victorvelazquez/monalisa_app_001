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
  Future<List<MInOut>> getMInOutList(WidgetRef ref) {
    return dataSource.getMInOutList(ref);
  }

  @override
  Future<List<MInOutConfirm>> getMInOutConfirmList(
      int mInOutId, WidgetRef ref) {
    return dataSource.getMInOutConfirmList(mInOutId, ref);
  }

  @override
  Future<MInOut> getMInOutAndLine(String mInOutDoc, WidgetRef ref) {
    return dataSource.getMInOutAndLine(mInOutDoc, ref);
  }

  @override
  Future<MInOutConfirm> getMInOutConfirmAndLine(
      int mInOutConfirmId, WidgetRef ref) {
    return dataSource.getMInOutConfirmAndLine(mInOutConfirmId, ref);
  }

  @override
  Future<MInOut> setDocAction(WidgetRef ref) {
    return dataSource.setDocAction(ref);
  }
}
