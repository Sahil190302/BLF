import 'package:blf/app/modules/Notification_Quick_Action/notification_controller.dart';
import 'package:blf/app/modules/Notifications/NotificationsView.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool showBackButton;
  final IconData? leadingIcon;
  final GlobalKey<ScaffoldState>? scaffoldKey;
  final bool showNotification;

  const CustomAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.leadingIcon,
    this.scaffoldKey,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {

  final NotificationController controller =
    Get.isRegistered<NotificationController>()
        ? Get.find<NotificationController>()
        : Get.put(NotificationController());

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.black,

      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : leadingIcon != null
              ? IconButton(
                  icon: Icon(leadingIcon, color: Colors.white),
                  onPressed: () {
                    scaffoldKey?.currentState?.openDrawer();
                  },
                )
              : null,

      title: Text(
        title.toUpperCase(),
        style: GoogleFonts.kumbhSans(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          color: AppColors.white,
          letterSpacing: 1,
        ),
      ),

      actions: [
        if (showNotification)
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () async {
                await Get.to(() => NotificationsView());
                controller.loadNotificationCount();
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [

                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),

                  Positioned(
                    right: -4,
                    top: -4,
                    child: Obx(() {

                      final count = controller.notificationCount.value;

                      if (count == 0) return const SizedBox();

                      return Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count > 9 ? "9+" : count.toString(),
                          style: GoogleFonts.kumbhSans(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: AppColors.white,
                            letterSpacing: 1,
                          ),
                        ),
                      );
                    }),
                  ),
                ],
              ),
            ),
          ),
      ],

      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.primary.withOpacity(0.09),
              AppColors.green.withOpacity(0.9),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}