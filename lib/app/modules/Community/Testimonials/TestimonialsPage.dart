import 'package:blf/app/modules/Community/Testimonials/TestimonialDetailsPage.dart';
import 'package:blf/app/modules/Community/Testimonials/TestimonialRequestPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'testimonials_controller.dart';

class TestimonialsPage extends StatefulWidget {
  const TestimonialsPage({super.key});

  @override
  State<TestimonialsPage> createState() => _TestimonialsPageState();
}

class _TestimonialsPageState extends State<TestimonialsPage> {
  final controller = Get.put(TestimonialsController());

  @override
  void initState() {
    super.initState();
    controller.loadReceived();
    controller.loadGiven();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: "BAC", showBackButton: true),

      body: Column(
        children: [
          // ---------------------------
          //   TAB BAR
          // ---------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _tabButton(
                      label: "Received (${controller.receivedCount})",
                      index: 0,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _tabButton(
                      label: "Given (${controller.givenCount})",
                      index: 1,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Expanded(
                  //   child: _tabButton(
                  //     label: "Requests (${controller.requestCount})",
                  //     index: 2,
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _receivedList();
              } else if (controller.selectedTab.value == 1) {
                return _givenList();
              } else {
                return _requestList();
              }
            }),
          ),
        ],
      ),
    );
  }

  // ----------------------------------
  // TAB BUTTON WIDGET
  // ----------------------------------
  Widget _tabButton({required String label, required int index}) {
    bool isActive = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 1.3),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.kumbhSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isActive ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  // ----------------------------------
  // RECEIVED TESTIMONIALS
  // ----------------------------------
  Widget _receivedList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.received.length,
      itemBuilder: (context, index) {
        var item = controller.received[index];
        return GestureDetector(
          onTap: () {
            Get.to(
              () => TestimonialDetailsPage(),
              arguments: {"data": item, "type": "received"},
            )?.then((value) {
              if (value == true) {
                controller.loadReceived();
              }
            });
          },
          child: _testimonialCard(item),
        );
      },
    );
  }

  // ----------------------------------
  // GIVEN TESTIMONIALS
  // ----------------------------------
  Widget _givenList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.given.length,
      itemBuilder: (context, index) {
        var item = controller.given[index];
        return GestureDetector(
          onTap: () {
            Get.to(
              () => TestimonialDetailsPage(),
              arguments: {"data": item, "type": "given"},
            )?.then((value) {
              if (value == true) {
                controller.loadGiven();
              }
            });
          },
          child: _testimonialCard(item),
        );
      },
    );
  }

  // ----------------------------------
  // REQUESTED TESTIMONIALS
  // ----------------------------------
  Widget _requestList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: controller.requests.length,
      itemBuilder: (context, index) {
        var item = controller.requests[index];

        return GestureDetector(
          onTap: () {
            Get.to(() => TestimonialRequestPage(), arguments: item);
          },
          child: _testimonialCard(item, isRequest: true),
        );
      },
    );
  }

  // ----------------------------------
  // TESTIMONIAL CARD
  // ----------------------------------
  Widget _testimonialCard(Map data, {bool isRequest = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),

      child: Row(
        children: [
          // PROFILE IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(40),
            child: Image.network(
              data["image"] ?? "",
              height: 50,
              width: 50,
              fit: BoxFit.cover,
              errorBuilder: (c, o, s) =>
                  Icon(Icons.person, size: 50, color: Colors.grey),
            ),
          ),

          const SizedBox(width: 14),

          // TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME + DATE
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        data["name"] ?? "",
                        style: GoogleFonts.kumbhSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black87,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          data["date"] ?? "",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 2),

                        Text(
                          "₹${data["amount"] ?? 0}",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // MESSAGE
                Text(
                  data["message"] ?? "",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          // RIGHT ARROW ICON
          Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey.shade500),
        ],
      ),
    );
  }
}
