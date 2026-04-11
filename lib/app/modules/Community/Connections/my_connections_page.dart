import 'package:blf/app/modules/Community/Connections/connection_profile_view.dart';
import 'package:blf/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'my_connections_controller.dart';

class MyConnectionsPage extends StatelessWidget {

  final controller = Get.put(MyConnectionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: CustomAppBar(
        title: "My Connections",
        showBackButton: true,
      ),

      body: Column(
        children: [

          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    hint: "Search By Name",
                    icon: Icons.search,
                    controller: controller.searchController,
                  ),
                ),

                const SizedBox(width: 10),

                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateSearch(
                        controller.searchController.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "Search",
                      style: GoogleFonts.kumbhSans(
                        fontWeight: FontWeight.w700,
                        color: AppColors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          // ---------------- CONNECTION LIST ----------------
          Expanded(
            child: Obx(() => ListView.builder(
              itemCount: controller.filteredConnections.length,
              itemBuilder: (context, index) {
                return _connectionTile(
                    controller.filteredConnections[index]);
              },
            )),
          ),
        ],
      ),
    );
  }

  // ---------------- CONNECTION TILE ----------------
  Widget _connectionTile(Map<String, String> data) {
    return GestureDetector(
      onTap: (){
      // Get.to(() => ConnectionProfileView(user: user));

      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: Colors.grey.shade300),
          ),
        ),
        child: Row(
          children: [

            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image.network(
                data["image"] ?? "",
                height: 46,
                width: 46,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                const Icon(Icons.person, size: 46),
              ),
            ),

            const SizedBox(width: 14),

            // NAME + PROFESSION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data["name"] ?? "",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    data["profession"] ?? "",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // ARROW
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
