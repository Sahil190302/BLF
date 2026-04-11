import 'package:blf/app/modules/Announcement/AnnouncementsView.dart';
import 'package:blf/app/modules/Event_view/event_view.dart';
import 'package:blf/app/modules/Notifications/NotificationsView.dart';
import 'package:blf/app/modules/ReportsDashboard/reports_dashboard_view.dart';
import 'package:blf/app/modules/auth/controller/login_controller.dart';
import 'package:blf/app/modules/auth/views/loginpage.dart';
import 'package:blf/app/modules/drawer/BirthdaysAnniversariesPage.dart';
import 'package:blf/app/modules/drawer/FeedbackPage.dart';
import 'package:blf/app/modules/drawer/MeetingSummaryPage.dart';
import 'package:blf/app/modules/drawer/PrivacyPolicyPage.dart';
import 'package:blf/app/modules/drawer/SettingsPage.dart';
import 'package:blf/app/modules/drawer/TermsOfServicePage.dart';
import 'package:blf/app/modules/drawer/about_app_page.dart';
import 'package:blf/app/modules/drawer/leave_rating_page.dart';
import 'package:blf/app/modules/drawer/support_page.dart';
import 'package:blf/app/services/app_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';

import '../app/modules/Gamification&Recognition/gamification_view.dart';

class CustomDrawer extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final String? userImageUrl;

  const CustomDrawer({
    super.key,
    this.userName,
    this.userEmail,
    this.userImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: AppColors.white,
        child: Column(
          children: [
            // Header with user profile
            _buildHeader(context),

            // Menu items
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  // _buildSectionTitle("BUSINESS"),

                  // _drawerItem(
                  //   icon: Icons.business_center,
                  //   label: "BLF App",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //   },
                  // ),

                  // _drawerItem(
                  //   icon: Icons.summarize,
                  //   label: "Meeting Summary",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => const MeetingSummaryPage());
                  //   },
                  // ),

                  // _drawerItem(
                  //   icon: Icons.settings,
                  //   label: "Settings",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => const SettingsPage());
                  //   },
                  // ),
                  _buildDivider(),
                  _buildSectionTitle("HELP & SUPPORT"),

                  _drawerItem(
                    icon: Icons.support_agent,
                    label: "Support",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const SupportPage());
                    },
                  ),

                  // _drawerItem(
                  //   icon: Icons.announcement,
                  //   label: "Announcements & Communication",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => AnnouncementsView());
                  //   },
                  // ),
                  // _drawerItem(
                  //   icon: Icons.emoji_events, // trophy icon for gamification
                  //   label: "Gamification & Recognition",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => GamificationView());
                  //   },
                  // ),
                  _drawerItem(
                    icon: Icons.notifications, // bell icon for notifications
                    label: "Notifications & Reminders",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => EventsView());
                    },
                  ),

                  // _drawerItem(
                  //   icon: Icons.cake, // cake icon for birthdays & anniversaries
                  //   label: "Birthdays & Anniversaries",
                  //   onTap: () {
                  //     Navigator.pop(context); // closes the drawer
                  //     Get.to(
                  //       () => BirthdaysAnniversariesPage(),
                  //     ); // navigates to the page
                  //   },
                  // ),

                  // _drawerItem(
                  //   icon: Icons.bar_chart,
                  //   label: "Reports Dashboard",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => ReportsDashboardView());
                  //   },
                  // ),
                  _drawerItem(
                    icon: Icons.feedback,
                    label: "Feedback",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => FeedbackPage());
                    },
                  ),

                  // _drawerItem(
                  //   icon: Icons.star,
                  //   label: "Leave a Rating",
                  //   onTap: () {
                  //     Navigator.pop(context);
                  //     Get.to(() => const LeaveRatingPage());
                  //   },
                  // ),
                  _buildDivider(),
                  _buildSectionTitle("ABOUT"),

                  _drawerItem(
                    icon: Icons.info,
                    label: "About",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const AboutAppPage());
                    },
                  ),

                  _drawerItem(
                    icon: Icons.description,
                    label: "Terms of Service",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const TermsOfServicePage());
                    },
                  ),

                  _drawerItem(
                    icon: Icons.security,
                    label: "Privacy Policy",
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(() => const PrivacyPolicyPage());
                    },
                  ),

                  _buildDivider(),

                  _drawerItem(
                    icon: Icons.logout,
                    label: "Logout",
                    color: Colors.red,
                    onTap: () {
                      Navigator.pop(context);
                      _showLogoutConfirmation(context);
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // App version at bottom
            // _buildAppVersion(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // User avatar
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    image: userImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(userImageUrl!),
                            fit: BoxFit.cover,
                          )
                        : const DecorationImage(
                            image: AssetImage('assets/default_avatar.png'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                const SizedBox(width: 15),

                // User info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName ?? "Guest User",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      if (userEmail != null)
                        Text(
                          userEmail!,
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // BLF member info
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.verified, color: Colors.white, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    "BLF Member",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color ?? AppColors.primary, size: 22),
      ),
      title: Text(
        label,
        style: GoogleFonts.kumbhSans(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: color ?? Colors.grey[800],
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey, size: 20),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 25, top: 20, bottom: 10),
      child: Text(
        title,
        style: GoogleFonts.kumbhSans(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Colors.grey[500],
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 20,
      thickness: 0.5,
      indent: 20,
      endIndent: 20,
      color: Colors.grey,
    );
  }

  Widget _buildAppVersion() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Text(
        "Version 1.0.0",
        style: GoogleFonts.kumbhSans(fontSize: 12, color: Colors.grey[500]),
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Logout",
          style: GoogleFonts.kumbhSans(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: GoogleFonts.kumbhSans(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "Cancel",
              style: GoogleFonts.kumbhSans(color: Colors.grey[600]),
            ),
          ),
          TextButton(
            onPressed: () {
              AppSession.clear(); // clear token + login state

              Get.offAll(() {
                Get.put(LoginController());
                return LoginView();
              });
            },
            child: Text(
              "Logout",
              style: GoogleFonts.kumbhSans(
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
