import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'add_connection_controller.dart';

class AddConnectionView extends StatelessWidget {
  AddConnectionView({super.key});

  final controller = Get.put(AddConnectionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        title: "Add Connection",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            /// SEARCH BAR
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: controller.searchController,
                      decoration: InputDecoration(
                        hintText: "Search by name",
                        border: InputBorder.none,
                        hintStyle: GoogleFonts.kumbhSans(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.searchConnection,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.search,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// SEARCH RESULT
            Obx(() {
              if (controller.isSearching.value) {
                return const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: CircularProgressIndicator(),
                );
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: controller.connections.length,
                  itemBuilder: (context, index) {
                    final item = controller.connections[index];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Row(
                        children: [
                          /// AVATAR
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: Colors.grey.shade300,
                            child: Text(
                              item["name"]![0],
                              style: GoogleFonts.kumbhSans(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// DETAILS
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item["name"]!,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["profession"]!,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item["group"]!,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 13,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// ADD BUTTON
                          GestureDetector(
                            onTap: () => controller.addConnection(index),
                            child: Container(
                              height: 36,
                              padding:
                              const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  "ADD",
                                  style: GoogleFonts.kumbhSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
