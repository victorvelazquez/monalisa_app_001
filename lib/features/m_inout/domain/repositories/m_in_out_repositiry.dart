import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/m_in_out.dart';
import '../entities/m_in_out_confirm.dart';

abstract class MInOutRepository {
  Future<List<MInOut>> getMInOutList(WidgetRef ref);
  Future<List<MInOutConfirm>> getMInOutConfirmList(int mInOutId, WidgetRef ref);
  Future<MInOut> getMInOutAndLine(String mInOutDoc, WidgetRef ref);
  Future<MInOutConfirm> getMInOutConfirmAndLine(int mInOutConfirmId, WidgetRef ref);
  Future<MInOut> setDocAction(WidgetRef ref);
}
