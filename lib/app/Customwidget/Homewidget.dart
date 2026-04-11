import 'package:blf/app/modules/Community/Groups/Groups_View.dart';
import 'package:blf/app/modules/Community/Testimonials/TestimonialsPage.dart';
import 'package:blf/app/modules/Event_view/event_view.dart';
import 'package:blf/app/modules/Gallery/gallery_view.dart';
import 'package:blf/app/modules/Notification_Quick_Action/notification_screen.dart';
import 'package:blf/app/modules/P2P/p2p_screen.dart';
import 'package:blf/app/modules/Referral/referral_screen.dart';
import 'package:blf/app/modules/Testimonials_Quick/testi_ui.dart';
import 'package:blf/app/modules/outsidereferral/outside_referral_view.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_images.dart';
import '../../widgets/Custom_Drawer.dart';
import '../modules/OneToOneMeeting/one_to_one_meeting_view.dart';
import '../modules/TYFCB/tyfcb_view.dart';
import '../modules/home/home_controller.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class TimePeriodSection extends StatelessWidget {
  final HomeController controller;

  const TimePeriodSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          /// ───── PERIOD BUTTONS (3M / 6M / LIFETIME) ─────
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: controller.periods.map((period) {
                final isSelected = controller.selectedPeriod.value == period;

                return GestureDetector(
                  onTap: () {
                    controller.changeTimePeriod(period);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.primary : AppColors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.lightGrey,
                      ),
                    ),
                    child: Text(
                      period,
                      style: GoogleFonts.kumbhSans(
                        color: isSelected ? AppColors.white : AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),

          /// ───── MONTH FILTER ─────
          Obx(
            () => Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.lightGrey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: controller.selectedMonth.value,
                  hint: const Text("Select Month"),
                  isExpanded: true,
                  icon: const Icon(Icons.keyboard_arrow_down),
                  items: controller.months.map((month) {
                    return DropdownMenuItem(
                      value: month,
                      child: Text(
                        month,
                        style: GoogleFonts.kumbhSans(fontSize: 14),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    controller.changeMonth(value);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          /// ───── STATS LIST ─────
          Obx(
            () => Column(
              children: controller.stats.map((stat) {
                final String type = stat['type'];
                final String value = (stat['displayValue'] as RxString).value;

                return _buildStatRow(
                  stat['title'],
                  value,
                  showRupee: type == 'amount',
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // Helper widget moved from home_page.dart
  Widget _buildStatRow(String title, String value, {bool showRupee = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[100]!, width: 1)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.kumbhSans(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            showRupee ? "₹ $value" : value,
            style: GoogleFonts.kumbhSans(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }
}

class ThisWeeksSlipsSection extends StatelessWidget {
  final HomeController controller;

  const ThisWeeksSlipsSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Punch Data",
          style: GoogleFonts.kumbhSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          return Column(
            children: [
              _buildSlipItem(
                title: controller.slips[0]['title'],
                // value: controller.slips[0]['displayValue'].value,
                onTap: () {
                  Get.to(() => TyfcbView()); // TYFCB PAGE
                },
                value: '',
              ),
              _buildSlipItem(
                title: controller.slips[1]['title'],
                value: controller.slips[1]['displayValue'].value,
                onTap: () {
                  Get.to(() => OutsideReferralView());
                },
              ),
              _buildSlipItem(
                title: controller.slips[2]['title'],
                value: controller.slips[2]['displayValue'].value,
                onTap: () {
                  Get.to(() => OneToOneMeetingView());
                },
              ),
              _buildSlipItem(
                title: controller.slips[3]['title'],
                value: controller.slips[3]['displayValue'].value,
                onTap: () {
                  Get.to(() => EventsView()); // TYFCB PAGE
                },
              ),
              // _buildSlipItem(
              //   title: controller.slips[3]['title'],
              //   value: controller.slips[3]['displayValue'].value,
              //   onTap: () {},
              // ),
              // _buildSlipItem(
              //   title: controller.slips[4]['title'],
              //   value: controller.slips[4]['displayValue'].value,
              //   onTap: () {
              // codespazio.com},
              // ),
            ],
          );
        }),
      ],
    );
  }

  // Helper widget also moved here
  Widget _buildSlipItem({
    required String title,
    required String? value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          border: Border.all(color: AppColors.primary, width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.kumbhSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.add, size: 18, color: AppColors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class NextMeetingSection extends StatelessWidget {
  final HomeController controller;

  const NextMeetingSection({super.key, required this.controller});

  void _showAbsentDialog(BuildContext context, int sno) {
    final TextEditingController reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Absent Reason"),
          content: TextField(
            controller: reasonController,
            decoration: const InputDecoration(
              labelText: "Add Reason",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.markAttendance(
                  sno: sno,
                  status: "Absent",
                  attend: reasonController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  void _showSubstituteDialog(BuildContext context, int sno) {
    final TextEditingController personController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("Substitute Person"),
          content: TextField(
            controller: personController,
            decoration: const InputDecoration(
              labelText: "Person Name",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                controller.markAttendance(
                  sno: sno,
                  status: "Substitute",
                  attend: personController.text.trim(),
                );
                Navigator.pop(context);
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 DYNAMIC MEETING SECTION
          Obx(() {
            if (controller.meetingNotifications.isEmpty) {
              return const SizedBox();
            }

            return ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 420),
              child: Scrollbar(
                thumbVisibility: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: controller.meetingNotifications.length,
                  itemBuilder: (context, index) {
                    final meeting = controller.meetingNotifications[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      width: double.infinity,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary.withOpacity(0.08),
                            AppColors.primary.withOpacity(0.02),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// HEADER
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.event_note_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      meeting["notification_title"] ?? "",
                                      style: GoogleFonts.kumbhSans(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.primaryDark,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      meeting["notification_type"] ?? "",
                                      style: GoogleFonts.kumbhSans(
                                        fontSize: 12,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// DATE
                          Row(
                            children: [
                              const Icon(Icons.schedule_rounded, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                meeting["date"] ?? "",
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 12),

                          /// DETAILS WITH READ MORE
                          _ExpandableDetail(
                            detail: meeting["notification_detail"] ?? "",
                          ),

                          const SizedBox(height: 12),

                          /// ✅ ATTENDANCE AREA (UNCHANGED)
                          Obx(() {
                            final status = controller.attendanceStatus.value;
                            final bool isMarked = status.isNotEmpty;
                            final bool isPresent = status == 'present';

                            if (isMarked) {
                              return Column(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isPresent
                                          ? Colors.green.withOpacity(0.1)
                                          : Colors.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: isPresent
                                            ? Colors.green
                                            : Colors.red,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        isPresent
                                            ? 'Marked as Present'
                                            : 'Marked as Absent',
                                        style: GoogleFonts.kumbhSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: isPresent
                                              ? Colors.green[700]
                                              : Colors.red[700],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }

                            return Column(
                              children: [
                                /// 💡 MOTIVATIONAL NOTE
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.lightbulb_outline_rounded,
                                        size: 18,
                                        color: Colors.black54,
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          "Consistency drives growth. Please make every attendance count.",
                                          style: GoogleFonts.kumbhSans(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 14),

                                /// ✅ PRESENT / ABSENT BUTTONS
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          controller.markAttendance(
                                            sno: meeting["sno"],
                                            status: "Present",
                                            attend: "Yes i will come",
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.green,
                                          size: 18,
                                        ),
                                        label: Text(
                                          "Present",
                                          style: GoogleFonts.kumbhSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.green,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.green,
                                            width: 1.5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          backgroundColor: Colors.green
                                              .withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          _showAbsentDialog(
                                            context,
                                            meeting["sno"],
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.cancel_rounded,
                                          color: Colors.red,
                                          size: 18,
                                        ),
                                        label: Text(
                                          "Absent",
                                          style: GoogleFonts.kumbhSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.red,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.red,
                                            width: 1.5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          backgroundColor: Colors.red
                                              .withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          _showSubstituteDialog(
                                            context,
                                            meeting["sno"],
                                          );
                                        },
                                        icon: const Icon(
                                          Icons.person_add_alt,
                                          color: Colors.orange,
                                          size: 18,
                                        ),
                                        label: Text(
                                          "Substitute",
                                          style: GoogleFonts.kumbhSans(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.orange,
                                          ),
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(
                                            color: Colors.orange,
                                            width: 1.5,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          backgroundColor: Colors.orange
                                              .withOpacity(0.05),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          }),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          }),

          const SizedBox(height: 10),

          /// GRID STATS (UNCHANGED)
          StaggeredGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            children: [
              Obx(
                () => _statTile(
                  'BAC GIVEN',
                  '${controller.thankYouGivenCount.value.toStringAsFixed(0)}',
                ),
              ),
              Obx(
                () => _statTile(
                  'BAC RECEIVED',
                  '${controller.thankYouReceivedCount.value.toStringAsFixed(0)}',
                ),
              ),
              Obx(
                () => _statTile(
                  'REFERRAL GIVEN',
                  controller.dashboardReferralGiven.value.toString(),
                ),
              ),
              Obx(
                () => _statTile(
                  'REFERRAL RECEIVED',
                  controller.dashboardReferralReceived.value.toString(),
                ),
              ),
              Obx(
                () => StaggeredGridTile.fit(
                  crossAxisCellCount: 2,
                  child: _statTile(
                    'P2P MEETINGS',
                    controller.p2pMeetingCount.value.toString(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableDetail extends StatefulWidget {
  final String detail;

  const _ExpandableDetail({required this.detail});

  @override
  State<_ExpandableDetail> createState() => _ExpandableDetailState();
}

class _ExpandableDetailState extends State<_ExpandableDetail> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    final parts = widget.detail.split("|");

    final bool isLong = parts.length > 2;

    final visibleParts = expanded ? parts : parts.take(2).toList();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 DETAILS LIST
          ...visibleParts.map((item) {
            final clean = item.trim();

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.circle, size: 6, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      clean,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[800],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          /// 🔹 READ MORE
          if (isLong)
            GestureDetector(
              onTap: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  expanded ? "Read Less" : "Read More",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// STAT TILE
Widget _statTile(String title, String value) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    decoration: BoxDecoration(
      color: AppColors.primary.withOpacity(0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.primary.withOpacity(0.4), width: 0.6),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.kumbhSans(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          textAlign: TextAlign.center,
          style: GoogleFonts.kumbhSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.grey[800],
          ),
        ),
      ],
    ),
  );
}

class CustomDrawerWidget extends StatelessWidget {
  const CustomDrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: HomeApi.fetchUser(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Drawer(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final user = snapshot.data!;

        const baseImageUrl =
            "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

        return CustomDrawer(
          userName: user["name"],
          userEmail: user["email"],
          userImageUrl:
              user["profile_image"] != null &&
                  user["profile_image"].toString().isNotEmpty
              ? baseImageUrl + user["profile_image"]
              : null,
        );
      },
    );
  }
}

class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// TITLE
          Text(
            "QUICK ACTIONS",
            style: GoogleFonts.kumbhSans(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: Colors.grey[600],
            ),
          ),

          const SizedBox(height: 12),

          /// GRID
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            childAspectRatio: 0.8,
            children: [
              _QuickActionItem(
                icon: Icons.handshake,
                label: "BAC",
                route: TestimonialsPage(),
              ),
              _QuickActionItem(
                icon: Icons.add_circle,
                label: "Referral",
                route: ReferralScreen(),
              ),
              _QuickActionItem(
                icon: Icons.people,
                label: "P2P",
                route: P2PScreen(),
              ),
              _QuickActionItem(
                icon: Icons.event,
                label: "Events",
                route: NotificationScreen(),
              ),
              _QuickActionItem(
                icon: Icons.handshake,
                label: "Product Appreciations",
                route: TestimonialScreen(),
              ),
              _QuickActionItem(
                icon: Icons.group,
                label: "Groups",
                route: GroupsView(),
              ),
              _QuickActionItem(
                icon: Icons.browse_gallery,
                label: "Gallery",
                route: GalleryView(),
              ),
              // _QuickActionItem(
              //   icon: Icons.groups,
              //   label: "Visitors",
              //   route: VisitorsView(),
              // ),
              // _QuickActionItem(
              //   icon: Icons.cake,
              //   label: "Birthdays",
              //   route: BirthdaysAnniversariesPage(),
              // ),

              // _QuickActionItem(
              //   icon: Icons.handshake,
              //   label: "TYFCB",
              //   route: TestimonialsPage(),
              // ),
              // _QuickActionItem(
              //   icon: Icons.notifications,
              //   label: "Notifications",
              //   route: NotificationScreen(),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 🔹 Single Quick Action Button (PRIVATE)
class _QuickActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget route;

  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => route),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.primary.withOpacity(0.4)),
            ),
            child: Icon(icon, size: 26, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.kumbhSans(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}

class UpcomingEventsSection extends StatelessWidget {
  final RxList<Map<String, dynamic>> events;
  final VoidCallback? onViewAll;

  const UpcomingEventsSection({
    super.key,
    required this.events,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// HEADER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "UPCOMING EVENTS",
                style: GoogleFonts.kumbhSans(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    "View All",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 12),

          /// EVENTS LIST
          Obx(() {
            if (events.isEmpty) {
              return _emptyState();
            }

            return Scrollbar(
              thumbVisibility: true,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: events.length,
                itemBuilder: (context, index) {
                  final event = events[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withOpacity(0.08),
                          AppColors.primary.withOpacity(0.02),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            event['icon'],
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                event['title'],
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                event['date'],
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 13,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          "No upcoming events",
          style: GoogleFonts.kumbhSans(fontSize: 13, color: Colors.grey[500]),
        ),
      ),
    );
  }
}

/// 🔹 SINGLE EVENT ROW
class _UpcomingEventRow extends StatelessWidget {
  final String title;
  final String date;
  final IconData icon;

  const _UpcomingEventRow({
    required this.title,
    required this.date,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

//bsc
class HomeHeaderSection extends StatelessWidget {
  final HomeController controller;

  const HomeHeaderSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.black, // fallback color until image loads
          image: DecorationImage(
            image: ResizeImage(
              AssetImage(AppImages.homecard3),
              width: 1200, // reduce decoding size
            ),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// PROFILE + INFO ROW
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// PROFILE WITH VERIFIED
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey[200]!, width: 3),
                      ),
                      child: ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: controller.profileImageUrl.value,

                          fit: BoxFit.cover,
                          progressIndicatorBuilder: (context, url, progress) =>
                              Center(
                                child: SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1,
                                    value: progress.progress,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.person,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.verified,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 20),

                /// USER INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userName.value,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.white,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        controller.company.value,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                       const SizedBox(height: 4),
                      
                      /// STATUS
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E8),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFFC8E6C9)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFF4CAF50),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "Active",
                              style: GoogleFonts.kumbhSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Divider(color: Colors.grey[200], height: 1),
            const SizedBox(height: 5),

            /// QUICK STATS
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildHeaderStat(
                  "Meetings",
                  controller.meetingsCount.value.toString(),
                ),
                _buildHeaderStat(
                  "Referrals",
                  controller.referralsCount.value.toString(),
                ),
                _buildHeaderStat("Revenue", controller.getFormattedRevenue()),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.kumbhSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.kumbhSans(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }
}
