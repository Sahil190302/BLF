import 'package:blf/app/modules/Testimonials_Quick/testi_controller.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';

class TestimonialScreen extends StatefulWidget {
  const TestimonialScreen({super.key});

  @override
  State<TestimonialScreen> createState() => _TestimonialScreenState();
}

class _TestimonialScreenState extends State<TestimonialScreen> {
  final controller = Get.put(TestimonialQuickController());

  @override
  void initState() {
    super.initState();
    controller.refreshTestimonials();// refresh when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: "Product Appreciations",
        showBackButton: true,
      ),

      body: Column(
        children: [
          const SizedBox(height: 15),

          // TABS
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(
              () => Row(
                children: [
                  Expanded(child: _tabButton("Given", 0)),
                  const SizedBox(width: 10),
                  Expanded(child: _tabButton("Recieved", 1)),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // LIST
          Expanded(
            child: Obx(() {
              if (controller.selectedTab.value == 0) {
                return _testimonialList(controller.received);
              } else {
                return _testimonialList(controller.given);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, int index) {
    bool active = controller.selectedTab.value == index;

    return GestureDetector(
      onTap: () => controller.changeTab(index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.kumbhSans(
              fontWeight: FontWeight.w700,
              color: active ? Colors.white : AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _testimonialList(List<Map<String, dynamic>> list) {
    if (list.isEmpty) {
      return Center(child: Text("No testimonials found"));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        var item = list[index];

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),

          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey.shade200,
                child: Icon(Icons.person, color: Colors.grey),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.selectedTab.value == 0
                              ? controller.userNames[item["member_id"]
                                        .toString()] ??
                                    "User"
                              : controller.userNames[item["user_id"]
                                        .toString()] ??
                                    "Member",
                          style: GoogleFonts.kumbhSans(
                            fontWeight: FontWeight.w700,
                            fontSize: 15,
                          ),
                        ),
                        Text(
                          item["date"] ?? "",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Text(
                      item["message"] ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),
        );
      },
    );
  }
}
