import 'package:blf/app/services/home_api.dart';
import 'package:get/get.dart';
import 'notification_api.dart';

class NotificationController extends GetxController {

  var isLoading = true.obs;
  var notifications = <Map<String, dynamic>>[].obs;
  var notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
    loadNotificationCount();
  }

  Future<void> loadNotifications() async {

    try {

      isLoading(true);

      final user = await HomeApi.fetchUser();
      final userId = user["sno"].toString();

      final data =
          await NotificationApi.fetchNotifications(userId: userId);

      notifications.assignAll(data);

    } catch (e) {

      notifications.clear();

    } finally {

      isLoading(false);

    }
  }

  Future<void> loadNotificationCount() async {

    try {

      final user = await HomeApi.fetchUser();
      final userId = user["sno"].toString();

      final count =
          await NotificationApi.fetchNotificationCount(userId: userId);

      notificationCount.value = count;

    } catch (e) {

      notificationCount.value = 0;

    }
  }

  Future<void> markAsRead(int index) async {

    try {

      final user = await HomeApi.fetchUser();
      final userId = user["sno"];

      final notificationId = notifications[index]["sno"];

      final success = await NotificationApi.processNotification(
        userId: userId,
        notificationId: notificationId,
      );

      if (success) {

        notifications.removeAt(index);

        if (notificationCount.value > 0) {
          notificationCount.value--;
        }
      }

    } catch (e) {}
  }
}