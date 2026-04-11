import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'received_requests_controller.dart';

class ReceivedRequestsPage extends StatelessWidget {
  ReceivedRequestsPage({super.key});

  final controller = Get.put(ReceivedRequestsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Received Requests",
        showBackButton: true,
      ),
      body: Obx(
            () => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.requests.length,
          itemBuilder: (context, index) {
            final data = controller.requests[index];
            return _requestCard(data, index);
          },
        ),
      ),
    );
  }

  // ================= REQUEST CARD =================
  Widget _requestCard(Map data, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // ---------------- TOP INFO ----------------
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  data["image"],
                  height: 46,
                  width: 46,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                  const Icon(Icons.person, size: 46),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["name"],
                      style: GoogleFonts.kumbhSans(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      data["profession"],
                      style: GoogleFonts.kumbhSans(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      data["chapter"],
                      style: GoogleFonts.kumbhSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                data["date"],
                style: GoogleFonts.kumbhSans(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ---------------- MESSAGE ----------------
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              data["message"],
              style: GoogleFonts.kumbhSans(
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),

          const SizedBox(height: 14),

          // ---------------- ACTION BUTTONS ----------------
          Row(
            children: [
              // GIVE BUTTON (RED)
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.giveTestimonial(index),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        "Accept",
                        style: GoogleFonts.kumbhSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // IGNORE BUTTON
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.ignoreRequest(index),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "IGNORE",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // REJECT BUTTON
              Expanded(
                child: GestureDetector(
                  onTap: () => controller.rejectRequest(index),
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Center(
                      child: Text(
                        "REJECT",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 14,
                        ),
                      ),
                    ),
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
