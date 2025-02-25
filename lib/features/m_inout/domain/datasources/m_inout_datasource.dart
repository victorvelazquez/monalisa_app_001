import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out_confirm.dart';

abstract class MInOutDataSource {
  Future<List<MInOut>> getMInOutList(WidgetRef ref);
  Future<List<MInOutConfirm>> getMInOutConfirmList(int mInOutId, WidgetRef ref);
  Future<MInOut> getMInOutAndLine(String mInOutDoc, WidgetRef ref);
  Future<MInOutConfirm> getMInOutConfirmAndLine(int mInOutConfirmId, WidgetRef ref);
  Future<MInOut> setDocAction(WidgetRef ref);
}
