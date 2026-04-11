import 'package:get/get.dart';

class BottomNavController extends GetxController {
  // Current selected index
  var selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }
}
