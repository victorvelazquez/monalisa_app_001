import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../entities/m_in_out.dart';

abstract class MInOutRepository {
  Future<MInOut> getMInOutAndLine(String mInOut, bool isSOTrx, WidgetRef ref);
}
