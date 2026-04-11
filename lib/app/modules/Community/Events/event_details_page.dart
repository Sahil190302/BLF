import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';

class EventDetailsPage extends StatelessWidget {
  const EventDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Event Details",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// EVENT TITLE
            Text(
              "Indian Executive Director Training Goa",
              style: GoogleFonts.kumbhSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.red,
              ),
            ),

            const SizedBox(height: 12),

            /// LOCATION
            _infoRow(Icons.location_on, "Goa, India"),

            /// START DATE
            _infoRow(Icons.play_circle_outline, "Start: 10 July 2025, 10:00 AM"),

            /// END DATE
            _infoRow(Icons.stop_circle_outlined, "End: 12 July 2025, 05:00 PM"),

            /// TIMEZONE
            _infoRow(Icons.language, "Asia / Kolkata"),

            const SizedBox(height: 16),

            /// ABOUT EVENT
            Text(
              "About Event",
              style: GoogleFonts.kumbhSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "This training program is designed for Executive Directors to enhance leadership, networking, and strategic growth skills. It includes workshops, networking sessions, and expert talks.",
              style: GoogleFonts.kumbhSans(
                fontSize: 13,
                color: AppColors.textLight,
              ),
            ),

            const SizedBox(height: 16),

            /// COST
            Text(
              "Cost",
              style: GoogleFonts.kumbhSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "₹ 5,000 (Members Only)",
              style: GoogleFonts.kumbhSans(
                fontSize: 14,
                color: AppColors.red,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            /// REGISTER BUTTON
            GestureDetector(
              onTap: () {
                // TODO: open online registration
              },
              child: Container(
                height: 48,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Register Online",
                  style: GoogleFonts.kumbhSans(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// REUSABLE INFO ROW
  Widget _infoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textLight),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.kumbhSans(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
