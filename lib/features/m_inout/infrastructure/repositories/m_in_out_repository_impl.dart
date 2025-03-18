import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/line_confirm.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/repositories/m_in_out_repositiry.dart';

import '../../domain/datasources/m_inout_datasource.dart';
import '../../domain/entities/line.dart';
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
  Future<List<MInOut>> getMovementList(WidgetRef ref) {
    return dataSource.getMovementList(ref);
  }

  @override
  Future<MInOut> getMovementAndLine(String movementDoc, WidgetRef ref) {
    return dataSource.getMovementAndLine(movementDoc, ref);
  }

  @override
  Future<List<MInOutConfirm>> getMovementConfirmList(
      int movementId, WidgetRef ref) {
    return dataSource.getMovementConfirmList(movementId, ref);
  }

  @override
  Future<MInOutConfirm> getMovementConfirmAndLine(
      int movementConfirmId, WidgetRef ref) {
    return dataSource.getMovementConfirmAndLine(movementConfirmId, ref);
  }

  @override
  Future<MInOut> setDocAction(WidgetRef ref) {
    return dataSource.setDocAction(ref);
  }

  @override
  Future<LineConfirm> updateLineConfirm(Line line, WidgetRef ref) {
    return dataSource.updateLineConfirm(line, ref);
  }

  @override
  Future<int> getLocator(String value, WidgetRef ref) {
    return dataSource.getLocator(value, ref);
  }

  @override
  Future<bool> updateLocator(Line line, WidgetRef ref) {
    return dataSource.updateLocator(line, ref);
  }
}
