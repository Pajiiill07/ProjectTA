import 'package:get/get.dart';
import 'package:frontend_mobile/app/data/controller/edukonten_controller.dart' as DataController;

class KontenController extends GetxController {
  // Instance dari data controller
  late DataController.EdukontenController _dataController;

  final count = 0.obs;

  // Proxy getters untuk mengakses data dari data controller
  get KontenList => _dataController.KontenList;
  get isLoading => _dataController.isLoading;

  @override
  void onInit() {
    super.onInit();
    // Initialize data controller
    _dataController = Get.find<DataController.EdukontenController>();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  // Proxy methods untuk mengakses fungsi dari data controller
  Future<void> fetchKonten() async {
    await _dataController.fetchKonten();
  }

  Future<void> refreshKonten() async {
    await _dataController.refreshKonten();
  }
}