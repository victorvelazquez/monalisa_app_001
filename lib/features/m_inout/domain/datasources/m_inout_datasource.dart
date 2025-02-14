import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monalisa_app_001/features/m_inout/domain/entities/m_in_out.dart';

abstract class MInOutDataSource {
  Future<MInOut> getMInOutAndLine(String mInOut, bool isSOTrx, WidgetRef ref);
  Future<MInOut> setDocAction(MInOut mInOut, bool isSOTrx, WidgetRef ref);
}
