import 'package:blf/app/modules/Community/Connections/add_connection_view.dart';
import 'package:blf/app/modules/Community/Connections/my_connections_page.dart';
import 'package:blf/app/modules/Community/Connections/received_requests_page.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';

class ConnectionsPage extends StatelessWidget {
  // Dummy counts (replace with API later)
  final RxInt myConnections = 25.obs;
  final RxInt sentRequests = 0.obs;
  final RxInt receivedRequests = 4.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(title: "Connections", showBackButton: true),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ------------------------
            // MY CONNECTIONS
            // ------------------------
            Obx(
              () => _connectionTile(
                icon: Icons.groups,
                title: "My Connections",
                count: myConnections.value,
                onTap: () {

                  Get.to(()=>MyConnectionsPage());
                  // TODO: Navigate to My Connections List
                  print("My Connections tapped");
                },
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------
            // SENT REQUESTS
            // ------------------------
            Obx(
              () => _connectionTile(
                icon: Icons.send,
                title: "Sent Requests",
                count: sentRequests.value,
                onTap: () {
                  // TODO: Navigate to Sent Requests
                  print("Sent Requests tapped");
                },
              ),
            ),

            const SizedBox(height: 12),

            // ------------------------
            // RECEIVED REQUESTS
            // ------------------------
            Obx(
              () => _connectionTile(
                icon: Icons.download,
                title: "Received Requests",
                count: receivedRequests.value,
                onTap: () {
                  Get.to(()=>ReceivedRequestsPage());

                  // TODO: Navigate to Received Requests
                  print("Received Requests tapped");
                },
              ),
            ),

            const Spacer(),

            // ------------------------
            // ADD CONNECTION BUTTON
            // ------------------------
            CustomButton(text: "Add Connection", onTap: () {
              Get.to(()=>AddConnectionView());

            }


            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------
  // CONNECTION TILE WIDGET
  // ------------------------------------------------
  Widget _connectionTile({
    required IconData icon,
    required String title,
    required int count,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Row(
          children: [
            // ICON
            Container(
              height: 38,
              width: 38,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),

            const SizedBox(width: 14),

            // TITLE
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.kumbhSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),

            // COUNT
            Text(
              "($count)",
              style: GoogleFonts.kumbhSans(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 10),

            // ARROW
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
