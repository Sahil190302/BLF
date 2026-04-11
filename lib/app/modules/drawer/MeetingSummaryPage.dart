import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';


class MeetingSummaryPage extends StatelessWidget {
  const MeetingSummaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Meeting Summary",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _item("Meeting Topic", "Business Growth Strategy"),
            _item("Date", "10 July 2025"),
            _item("Duration", "1 Hour"),
            _item("Notes",
                "Discussed growth plans, partnerships and next milestones."),
          ],
        ),
      ),
    );
  }

  Widget _item(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.kumbhSans(
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.kumbhSans(
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
}
