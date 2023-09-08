import 'package:get/get.dart';

import '../controller/all_orders_controller.dart';

class OrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AllOrdersController());
  }
}