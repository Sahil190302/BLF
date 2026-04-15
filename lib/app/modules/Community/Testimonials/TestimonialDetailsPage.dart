import 'package:blf/app/modules/Community/Testimonials/testimonials_api.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';

class TestimonialDetailsPage extends StatelessWidget {
  final args = Get.arguments ?? {};
  late final data = args["data"] ?? {};
  late final type = args["type"] ?? "received";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: CustomAppBar(
        title: type == "given" ? "Given" : "Received",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _topCard(),

            const SizedBox(height: 20),

            _contentBlock(),

            const SizedBox(height: 20),

            _displayToggle(),

            // const SizedBox(height: 10),

            // _deleteButton(),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------
  // TOP PROFILE CARD
  // ------------------------------------------------------
  Widget _topCard() {
    final String imagePath = data["image"] ?? "";
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: CachedNetworkImage(
              imageUrl: imagePath.startsWith("http")
                  ? imagePath
                  : "${TestimonialsApi.baseImageUrl}$imagePath",
              height: 55,
              width: 55,
              fit: BoxFit.cover,
              progressIndicatorBuilder: (context, url, progress) =>
                  const SizedBox(
                    height: 25,
                    width: 25,
                    child: CircularProgressIndicator(strokeWidth: 1),
                  ),
              errorWidget: (context, url, error) =>
                  const Icon(Icons.person, size: 40, color: Colors.grey),
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
                style: GoogleFonts.kumbhSans(fontSize: 12, color: Colors.grey),
              ),

              const SizedBox(height: 4),

              Text(
                "Amount: ₹${data["amount"] ?? 0}",
                style: GoogleFonts.kumbhSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // FULL TESTIMONIAL CONTENT
  // ------------------------------------------------------
  Widget _contentBlock() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.format_quote, color: Colors.grey, size: 32),

          const SizedBox(height: 10),

          Text(
            data["fullMessage"] ?? data["message"],
            style: GoogleFonts.kumbhSans(fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------
  // DISPLAY TOGGLE
  // ------------------------------------------------------
  Widget _displayToggle() {
    return Row(
      children: [
        Checkbox(
          value: true,
          onChanged: (v) {},
          activeColor: AppColors.primary,
        ),
        Text(
          "Display this Testimonial in my profile",
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------
  // DELETE BUTTON
  // ------------------------------------------------------
  Widget _deleteButton() {
    return GestureDetector(
      onTap: () {
        Get.defaultDialog(
          title: "Delete Testimonial?",
          middleText: "Are you sure you want to delete this testimonial?",
          textConfirm: "Delete",
          confirmTextColor: Colors.white,
          onConfirm: () async {
            final int id = data["sno"]; // RECEIVED API sno

            final success = await TestimonialsApi.deleteTestimonial(id);

            Get.back(); // close dialog

            if (success) {
              Get.back(result: true); // go back to list
            }
          },
          textCancel: "Cancel",
        );
      },
      child: Row(
        children: [
          Icon(Icons.delete, color: Colors.red),
          const SizedBox(width: 8),
          Text(
            "Delete Testimonial",
            style: GoogleFonts.kumbhSans(
              fontSize: 15,
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
