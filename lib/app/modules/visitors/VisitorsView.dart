import 'package:blf/app/modules/visitors/visitor_detail_view.dart';
import 'package:blf/app/modules/visitors/visitors_controllers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class VisitorsView extends StatelessWidget {
  const VisitorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VisitorsController());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "VISITORS"),
      body: Column(
        children: [
          Obx(() => _buildTabSection(controller)),
          const SizedBox(height: 10),
          Expanded(
            child: Obx(() {
              return controller.selectedTab.value == 0
                  ? _buildInviteSection()
                  : _buildVisitorsList(controller);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSection(VisitorsController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.darkgreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Row(
            children: [
              _buildTabButton(controller, 0, 'INVITE'),
              const SizedBox(width: 5),
              _buildTabButton(controller, 1, 'VISITORS LIST'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(
    VisitorsController controller,
    int index,
    String text,
  ) {
    final isSelected = controller.selectedTab.value == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTab.value = index,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryDark : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              text,
              style: GoogleFonts.kumbhSans(
                color: AppColors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> openGmail() async {
    final Uri gmailUri = Uri.parse(
      "googlegmail://co?subject=Visitor Invitation&body=You are invited.",
    );

    if (await canLaunchUrl(gmailUri)) {
      await launchUrl(gmailUri);
    } else {
      final Uri fallback = Uri.parse(
        "mailto:?subject=Visitor Invitation&body=You are invited.",
      );

      await launchUrl(fallback);
    }
  }

  void _showShareDialog() {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Share Invite Link"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            _shareOption("Gmail", Icons.email, Colors.red, () {
              Navigator.pop(Get.context!);
              openGmail();
            }),

            const SizedBox(height: 10),

            _shareOption("SMS", Icons.sms, Colors.blue, () {
              Navigator.pop(Get.context!);
              openSMS();
            }),
          ],
        ),
      ),
    );
  }

  Future<void> openWhatsApp() async {
    final Uri whatsappUri = Uri.parse(
      "https://wa.me/?text=You are invited to visit.",
    );

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _shareOption(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade100,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(width: 12),
            Text(
              title,
              style: GoogleFonts.kumbhSans(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> openSMS() async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: '',
      queryParameters: {'body': 'You are invited to visit.'},
    );

    if (await canLaunchUrl(smsUri)) {
      await launchUrl(smsUri);
    }
  }

  Widget _buildInviteSection() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      children: [
        _inviteButton("Invite via Gmail", Icons.email, () {
          openGmail();
        }),
        const SizedBox(height: 12),

        _inviteButton("Invite via SMS", Icons.sms, () {
          openSMS();
        }),
        const SizedBox(height: 12),

        _inviteButton("Share Invite Link", Icons.share, () {
          _showShareDialog();
        }),
        const SizedBox(height: 12),

        // _inviteButton("Register a Visit", Icons.person_add, () {}),
        // const SizedBox(height: 12),

        // _inviteButton("Myself", Icons.person, () {}),
      ],
    );
  }

  Widget _inviteButton(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 28),
            const SizedBox(width: 15),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.kumbhSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryDark,
              size: 28,
            ),
          ],
        ),
      ),
    );
  }

 Widget _buildVisitorsList(VisitorsController controller) {
  if (controller.isLoading.value) {
    return const Center(child: CircularProgressIndicator());
  }

  if (controller.visitors.isEmpty) {
    return const Center(child: Text("No Visitors Found"));
  }

  return ListView.separated(
    padding: const EdgeInsets.all(15),
    itemCount: controller.visitors.length,
    separatorBuilder: (_, __) => const SizedBox(height: 10),
    itemBuilder: (context, index) {
      var item = controller.visitors[index];

      return GestureDetector(
        onTap: () {
          Get.to(() => VisitorDetailView(visitor: item));
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26,
                backgroundColor: AppColors.primaryDark.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  color: AppColors.primaryDark,
                  size: 28,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      item["name"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item["business_category"] ?? "",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      item["date"] ?? "",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.chevron_right_rounded,
                size: 26,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
