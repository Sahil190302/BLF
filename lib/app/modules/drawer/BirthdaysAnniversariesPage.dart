import 'package:blf/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../widgets/custom_appbar.dart';

class BirthdaysAnniversariesPage extends StatelessWidget {
  const BirthdaysAnniversariesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Birthdays & Anniversaries",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FeatureTile(
              icon: Icons.cake,
              title: "Automated Tracking",
              description: "Member birthdays and anniversaries are tracked via their profiles automatically.",
            ),
            FeatureTile(
              icon: Icons.message,
              title: "Auto-Wish System",
              description: "Sends wishes through notifications and WhatsApp without manual effort.",
            ),
            FeatureTile(
              icon: Icons.broadcast_on_home,
              title: "Admin Broadcast",
              description: "Admins can send group wishes or special messages to multiple members at once.",
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const FeatureTile({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 2,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 32, color: AppColors.primaryDark),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryDark,
                    )),
                const SizedBox(height: 4),
                Text(description,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 14,
                      color: Colors.grey[800],
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
