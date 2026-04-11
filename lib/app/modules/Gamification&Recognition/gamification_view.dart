import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import 'GamificationController.dart';

class GamificationView extends StatelessWidget {
  GamificationView({super.key});

  final GamificationController controller = Get.put(GamificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Gamification & Recognition",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Obx(
              () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Points Summary
              Text(
                "Points Summary",
                style: GoogleFonts.kumbhSans(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 10),
              Card(
                color: Colors.white,
                elevation: 1,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Total Points: ${controller.totalPoints.value}",
                            style: GoogleFonts.kumbhSans(fontSize: 16)),
                        Text("Referrals: ${controller.referralPoints.value} pts",
                            style: GoogleFonts.kumbhSans(fontSize: 14)),
                        Text("TYFCB: ${controller.tyfcbPoints.value} pts",
                            style: GoogleFonts.kumbhSans(fontSize: 14)),
                        Text("1-to-1s: ${controller.oneToOnePoints.value} pts",
                            style: GoogleFonts.kumbhSans(fontSize: 14)),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              // Monthly Leaderboard
              Text(
                "Monthly Leaderboard",
                style: GoogleFonts.kumbhSans(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.leaderboard.length,
                itemBuilder: (context, index) {
                  final member = controller.leaderboard[index];
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                          backgroundColor: AppColors.primary,
                          child: Text("${index + 1}", style: const TextStyle(color: Colors.white))),
                      title: Text(member.name,
                          style: GoogleFonts.kumbhSans(fontSize: 14, fontWeight: FontWeight.w600)),
                      trailing: Text("${member.points} pts",
                          style: GoogleFonts.kumbhSans(fontSize: 14)),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),
              // Badges
              Text(
                "Badges Earned",
                style: GoogleFonts.kumbhSans(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.badges.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.8,
                ),
                itemBuilder: (context, index) {
                  final badge = controller.badges[index];
                  return Column(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Image.network(badge.imageUrl, height: 40, fit: BoxFit.contain),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(badge.name,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.kumbhSans(fontSize: 12)),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),
              // Certificates
              Text(
                "Certificates",
                style: GoogleFonts.kumbhSans(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primaryDark),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.certificates.length,
                itemBuilder: (context, index) {
                  final cert = controller.certificates[index];
                  return Card(
                    color: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(cert.title,
                          style: GoogleFonts.kumbhSans(fontSize: 14, fontWeight: FontWeight.w600)),
                      subtitle: Text(cert.date,
                          style: GoogleFonts.kumbhSans(fontSize: 12, color: Colors.grey[700])),
                      trailing: const Icon(Icons.download, color: AppColors.primary),
                    ),
                  );
                },
              ),

            ],
          ),
        ),
      ),
    );
  }
}

// ============================ Controller ============================

