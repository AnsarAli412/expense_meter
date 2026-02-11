import 'package:get/get.dart';
import 'expense_controller.dart';

class ExpenseBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ExpenseController>(ExpenseController());
  }
}
