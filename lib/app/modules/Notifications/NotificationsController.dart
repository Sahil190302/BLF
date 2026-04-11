import 'package:blf/app/services/home_api.dart';
import 'package:get/get.dart';
import 'notifications_api.dart';

class NotificationItem {
  int sno;
  String title;
  String description;
  String type;
  bool isRead;

  NotificationItem({
    required this.sno,
    required this.title,
    required this.description,
    required this.type,
    this.isRead = false,
  });
}

class NotificationsController extends GetxController {

  var notifications = <NotificationItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {

    try {

      final user = await HomeApi.fetchUser();
      final userId = user["sno"].toString();

      final response =
          await NotificationsApi.fetchNotifications(userId: userId);

      final loadedNotifications = response.map((item) {

        return NotificationItem(
          sno: item["sno"],
          title: item["notification_title"] ?? "",
          description: item["notification_detail"] ?? "",
          type: item["notification_type"] ?? "",
          isRead: item["user_seen"] == 1,
        );

      }).toList();

      notifications.assignAll(loadedNotifications);

    } catch (e) {
      print("Notification Fetch Error: $e");
    }
  }

  Future<bool> markAsRead(int index) async {

    try {

      final user = await HomeApi.fetchUser();
      final userId = user["sno"];

      final notificationId = notifications[index].sno;

      final success = await NotificationsApi.processNotification(
        userId: userId,
        notificationId: notificationId,
      );

      if (success) {
        notifications.removeAt(index);
      }

      return success;

    } catch (e) {
      print("Mark Read Error: $e");
      return false;
    }
  }

  void addNotification(NotificationItem notification) {
    notifications.add(notification);
  }
}