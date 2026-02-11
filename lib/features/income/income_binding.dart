import 'package:get/get.dart';
import 'income_controller.dart';

class IncomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IncomeController>(IncomeController());
  }
}
