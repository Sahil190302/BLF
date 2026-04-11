import 'package:blf/app/modules/Notification_Quick_Action/notification_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'notification_controller.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}
class _NotificationScreenState extends State<NotificationScreen> {
  final NotificationController controller = Get.put(NotificationController());

  @override
  void initState() {
    super.initState();
    controller.loadNotifications(); // refresh when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: CustomAppBar(title: "Events", showBackButton: true),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.notifications.isEmpty) {
          return const Center(child: Text("No notifications found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,

          itemBuilder: (context, index) {
            final item = controller.notifications[index];
            final type = item["notification_type"] ?? "";

            String readableType;
            Color badgeColor;

            switch (type.toLowerCase()) {
              case "once":
                readableType = "Repeated Once";
                badgeColor = Colors.blue;
                break;
              case "yearly":
                readableType = "Repeated Yearly";
                badgeColor = Colors.green;
                break;
              default:
                readableType = type;
                badgeColor = Colors.grey;
            }

            return GestureDetector(
  onTap: () async {
  final result = await Get.to(
    () => NotificationDetailScreen(data: item),
  );

  if (result == true) {
    controller.loadNotifications();
  }
},
  child: Container(
    margin: const EdgeInsets.only(bottom: 14),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item["notification_title"] ?? "",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  readableType,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              item["notification_push_date"] ?? "",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 6),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ],
    ),
  ),
);
          },
        );
      }),
    );
  }
}
