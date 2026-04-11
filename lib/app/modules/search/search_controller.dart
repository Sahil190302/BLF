import 'package:get/get.dart';
import 'search_model.dart';
import 'search_api.dart';

class search_controller extends GetxController {
  var query = "".obs;

  var users = <SearchUser>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    fetchUsers();
    super.onInit();
  }

  void fetchUsers() async {
    isLoading.value = true;

    final data = await SearchApi.fetchUsers();

    users.assignAll(data);

    isLoading.value = false;
  }

  List<SearchUser> searchFilteredList() {
  if (query.value.isEmpty) {
    return users;
  }

  final q = query.value.toLowerCase();

  return users.where((user) {
    return user.name.toLowerCase().contains(q) ||
        user.city.toLowerCase().contains(q) ||
        user.businessName.toLowerCase().contains(q)||
        user.category.toLowerCase().contains(q);
  }).toList();
}
}