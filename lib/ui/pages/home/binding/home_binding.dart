import 'package:get/get.dart';
import '../controller/home_controller_tab.dart';

class HomeBinding extends Bindings {

  @override
  void dependencies() {
    Get.put(HomeController());
  }

}