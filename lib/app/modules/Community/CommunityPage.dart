import 'package:blf/app/modules/Community/Connections/Connections_page.dart';
import 'package:blf/app/modules/Community/Events/event_details_page.dart';
import 'package:blf/app/modules/Community/Events/upcoming_events.dart';
import 'package:blf/app/modules/Community/Groups/Groups_View.dart';
import 'package:blf/app/modules/Community/Testimonials/TestimonialsPage.dart';
import 'package:blf/app/modules/Event_view/event_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../utils/app_colors.dart';
// import your pages here
// import '../groups/groups_page.dart';

class CommunityPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: "COMMUNITY",
        showBackButton: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "Get Networking",
              style: GoogleFonts.kumbhSans(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                height: 1.1,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 35),

            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _cardItem(
                  Icons.group,
                  "Groups",
                  onTap: () {
                    // 👉 Navigate groups page
                    Get.to(() => GroupsView());
                  },
                ),

                _cardItem(
                  Icons.reviews,
                  "Testimonials",
                  onTap: () {
                    Get.to(() => TestimonialsPage());

                    // 👉 Navigate Testimonials Page
                  },
                ),

                _cardItem(
                  Icons.handshake,
                  "Connections",
                  onTap: () {
                    Get.to(() => ConnectionsPage());

                    // 👉 Navigate Connections Page
                  },
                ),

                _cardItem(
                  Icons.calendar_month,
                  "Events",
                  onTap: () {
                    Get.to(() => EventsView());

                    // 👉 Navigate Events Page
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // CARD ITEM WITH CALLBACK
  Widget _cardItem(IconData icon, String title, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: AppColors.red,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: Colors.white),
            const SizedBox(height: 14),
            Text(
              title,
              style: GoogleFonts.kumbhSans(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
