import 'package:get/get.dart';

import '../controllers/history_deteksi_controller.dart';

class HistoryDeteksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryDeteksiController>(
      () => HistoryDeteksiController(),
    );
  }
}
