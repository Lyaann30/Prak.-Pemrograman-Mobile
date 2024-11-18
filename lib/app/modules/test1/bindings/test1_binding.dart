import 'package:get/get.dart';

import '../controllers/test1_controller.dart';

class Test1Binding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<Test1Controller>(
      () => Test1Controller(),
    );
  }
}
