import 'package:get/get.dart';
import 'yearly_report_controller.dart';

class YearlyReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<YearlyReportController>(YearlyReportController());
  }
}
