import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import 'TestimonialRequestController.dart';

class TestimonialRequestPage extends StatelessWidget {
  final TestimonialRequestController controller = Get.put(
    TestimonialRequestController(),
    permanent: false,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CustomAppBar(title: "Testimonial Requests", showBackButton: true),

      body: Obx(() {
        if (controller.requests.isEmpty) {
          return const Center(child: Text("No Requests Found"));
        }

        return ListView.separated(
          padding: const EdgeInsets.all(10),
          itemCount: controller.requests.length,
          separatorBuilder: (_, __) => const SizedBox(height: 14),
          itemBuilder: (context, index) {
            final data = controller.requests[index];
            return _requestCard(data, index);
          },
        );
      }),
    );
  }

  Widget _requestCard(Map<String, dynamic> data, int index) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 1, offset: Offset(0, 0)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.network(
                  data["image"] ?? "",
                  height: 55,
                  width: 55,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.person, size: 55),
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"] ?? "",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    data["date"] ?? "",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            data["message"] ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.kumbhSans(fontSize: 14, height: 1.4),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
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
                        "ACCEPT",
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
                          color: Colors.black,
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
