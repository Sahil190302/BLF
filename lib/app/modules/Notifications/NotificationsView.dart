import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import 'NotificationsController.dart';

class NotificationsView extends StatelessWidget {
  NotificationsView({super.key});

  final NotificationsController controller = Get.put(NotificationsController());

  void showNotificationDetail(BuildContext context, NotificationItem item) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Icon(
              Icons.notifications_active,
              size: 45,
              color: AppColors.primaryDark,
            ),

            const SizedBox(height: 12),

            Text(
              item.title,
              textAlign: TextAlign.center,
              style: GoogleFonts.kumbhSans(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),

            const SizedBox(height: 15),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      item.description,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 14,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Notifications & Reminders",
        showBackButton: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(12),

        child: Obx(() {
          if (controller.notifications.isEmpty) {
            return const Center(child: Text("No notifications to show."));
          }

          return ListView.builder(
            itemCount: controller.notifications.length,

            itemBuilder: (context, index) {
              final item = controller.notifications[index];

              return GestureDetector(
                onTap: () => showNotificationDetail(context, item),

                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  child: Padding(
                    padding: const EdgeInsets.all(16),

                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primaryDark.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            Icons.notifications,
                            color: Colors.blue,
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: item.isRead
                                      ? Colors.grey
                                      : AppColors.primaryDark,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text(
                                item.type,
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!item.isRead)
                          SizedBox(
                            height: 38,
                            width: 110,
                            child: CustomButton(
                              text: "Mark as Read",
                              fontSize: 12,
                              onTap: () async {
                                await controller.markAsRead(index);
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
