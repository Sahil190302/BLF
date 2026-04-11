import 'package:blf/app/modules/UpdateStatus/update_status_page.dart';
import 'package:blf/app/modules/given/given_detalis_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/app/modules/slips/slips_controller.dart';
import 'package:blf/widgets/custom_appbar.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_images.dart';
import '../outsidereferral/outside_referral_view.dart';

class SlipsView extends StatelessWidget {
  const SlipsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SlipsController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "ACTIVITY FEED"),
      body: Column(
        children: [
          Obx(() => _buildTabSection(controller)),
          Expanded(child: _buildSlipsList(controller)),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(controller),
    );
  }
  // ----------------------- TAB SECTION -----------------------
  Widget _buildTabSection(SlipsController controller) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.darkgreen.withOpacity(1), // Dark Gre// en

          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            children: [
              _buildTabButton(controller, 0, 'GIVEN'),
              const SizedBox(width: 5),
              _buildTabButton(controller, 1, 'RECEIVED'),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTabButton(SlipsController controller, int index, String text) {
    final isSelected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primaryColor.withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.kumbhSans(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }
  // ----------------------- SLIPS LIST -----------------------
  Widget _buildSlipsList(SlipsController controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 15,right: 15 ),
      child: Obx(() {
        final slips = controller.currentList;

        if (slips.isEmpty) return _buildEmptyState();

        return ListView.separated(
          itemCount: slips.length,
          physics: BouncingScrollPhysics(),
          separatorBuilder: (context
              , index) => const SizedBox(height: 5),
          itemBuilder: (context, index) {
            return _buildSlipCard(slips[index],controller);
          },
        );
      }),
    );
  }
  Widget _buildSlipCard(Slip slip,controller) {
    return GestureDetector(
      onTap: () {
        _openSlipBottomSheet(slip, controller);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primaryshipcart, // fallback color until image loads
          image: DecorationImage(
            image: AssetImage(AppImages.silpscardimage),
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 60,
              decoration: BoxDecoration(
                color: _getStatusColor(slip.status),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
      
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          slip.name,
                          style: GoogleFonts.kumbhSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      Text(
                        slip.formattedAmount,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    slip.formattedDate,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                  ),
                  if (slip.description != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      slip.description!,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppColors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (slip.category != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        slip.category!,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
      
            const SizedBox(width: 0),
            GestureDetector(onTap:(){
              if (controller.selectedTab.value == 0) {
                // GIVEN
                Get.to(GivenDetalisPage());
              } else {
                // RECEIVED
                Get.to(UpdateStatusPage()); // <-- your page here
              }
              },child: Icon(Icons.chevron_right_rounded, color: AppColors.white, size: 30)),
          ],
        ),
      ),
    );
  }
  void _openSlipBottomSheet(Slip slip, SlipsController controller) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ---- Top Handle ----
            Center(
              child: Container(
                height: 5,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// ---- NAME & AMOUNT ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  slip.name,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryDark,
                  ),
                ),
                Text(
                  slip.formattedAmount,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// ---- DATE ----
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_month_rounded,
                      size: 22,
                      color: AppColors.primaryDark.withOpacity(0.8)),
                  const SizedBox(width: 8),
                  Text(
                    slip.formattedDate,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 25),

            /// ---- ACTION BUTTONS ----
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // Add your edit action here
                  },
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical:2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.remove_red_eye_outlined,
                            size: 28, color: AppColors.primaryDark),
                        const SizedBox(height: 6),
                        Text(
                          "View",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// EDIT BUTTON
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // Add your edit action here
                  },
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical:2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.edit_rounded,
                            size: 28, color: AppColors.primaryDark),
                        const SizedBox(height: 6),
                        Text(
                          "Edit",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primaryDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// DELETE BUTTON
                GestureDetector(
                  onTap: () {
                    Get.back();
                    // Add your delete action here
                  },
                  child: Container(
                    width: 70,
                    padding: const EdgeInsets.symmetric(vertical:2),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.red,
                        width: 1.2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(Icons.delete_rounded,
                            size: 28, color: Colors.red.shade700),
                        const SizedBox(height: 6),
                        Text(
                          "Delete",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_rounded,
            size: 64,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No Slips Found',
            style: GoogleFonts.kumbhSans(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'When you give or receive referrals,\nthey will appear here.',
            textAlign: TextAlign.center,
            style: GoogleFonts.kumbhSans(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildFloatingActionButton(SlipsController controller) {
    return Obx(() {
      return Stack(
        alignment: Alignment.bottomRight,
        children: [
          if (controller.isFabOpen.value) ...[
            _buildMiniFab(
              icon: Icons.group_add_rounded,
              label: "TYFCB",
              bottom: 230,
              onTap: () {},
            ),
            _buildMiniFab(
              icon: Icons.handshake_rounded,
              label: "Outside Referral",
              bottom: 180,
              onTap: () {
                Get.to(() => OutsideReferralView());
              },
            ),
            _buildMiniFab(
              icon: Icons.person_add_alt_1,
              label: "Inside Referral",
              bottom: 130,
              onTap: () {},
            ),
            _buildMiniFab(
              icon: Icons.chat_rounded,
              label: "One-to-One",
              bottom: 80,
              onTap: () {},
            ),
          ],

          Positioned(
            bottom: 20,
            right: 20,
            child:FloatingActionButton(
              heroTag: "main_fab",
              backgroundColor: AppColors.darkgreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              onPressed: controller.toggleFab,
              child: Icon(
                controller.isFabOpen.value ? Icons.close : Icons.add,
                color: Colors.white,
                size: 28,
              ),
            )

          ),
        ],
      );
    });
  }
  Widget _buildMiniFab({
    required IconData icon,
    required String label,
    required double bottom,
    required VoidCallback onTap,
  }) {
    return Positioned(
      bottom: bottom,
      right: 26,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              label,
              style: GoogleFonts.kumbhSans(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.white,
                letterSpacing: 1.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FloatingActionButton.small(
            heroTag: label,   // unique tag for each mini FAB
            backgroundColor: AppColors.primaryDark,
            onPressed: onTap,
            child: Icon(icon, color: Colors.white, size: 20),
          )

        ],
      ),
    );
  }
  Color _getStatusColor(SlipStatus status) {
    switch (status) {
      case SlipStatus.completed:
        return Colors.green;
      case SlipStatus.pending:
        return Colors.orange;
      case SlipStatus.cancelled:
        return Colors.red;
    }
  }
}
