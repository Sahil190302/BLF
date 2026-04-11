import 'package:blf/app/modules/Community/Groups/GroupsController.dart';
import 'package:blf/app/modules/Community/Groupsdetalis/group_details_view.dart';
import 'package:blf/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';

class GroupsView extends StatefulWidget {
  const GroupsView({super.key});

  @override
  State<GroupsView> createState() => _GroupsViewState();
}
class _GroupsViewState extends State<GroupsView> {
  final GroupsController controller = Get.put(GroupsController());

  @override
  void initState() {
    super.initState();
    controller.fetchGroups();   // refresh groups when screen opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Groups", showBackButton: true),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Expanded(child: _tabButton("My Groups", Icons.groups)),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(child: _searchBar()),
                const SizedBox(width: 10),
                _searchIcon(),
                const SizedBox(width: 10),
                _filterIcon(),
              ],
            ),
          ),

          const SizedBox(height: 15),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var filtered = controller.groups.where((group) {
                final name = (group["name"] ?? "").toLowerCase();

                final desc = (group["description"] ?? "").toLowerCase();

                final search = controller.searchQuery.value.toLowerCase();

                return name.contains(search) || desc.contains(search);
              }).toList();

              if (filtered.isEmpty) {
                return const Center(child: Text("No Groups Found"));
              }

              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  return _groupCard(filtered[i]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _tabButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary, width: 1.3),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: AppColors.primary, size: 18),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.kumbhSans(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return CustomTextField(
      hint: "Search Title, Description or Topics",
      icon: Icons.search,
      controller: controller.searchController,
    );
  }

  Widget _searchIcon() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.search, color: Colors.white),
    );
  }

  Widget _filterIcon() {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.filter_list, color: Colors.white),
    );
  }

  Widget _groupCard(dynamic group) {
    return GestureDetector(
      onTap: () {
       Get.to(() => GroupDetailsView(), arguments: group);
      },

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(12),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    group["icon"],
                    height: 60,
                    width: 60,
                    fit: BoxFit.cover,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        group["name"],
                        style: GoogleFonts.kumbhSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),

                      Text(
                        group["since"],
                        style: GoogleFonts.kumbhSans(
                          fontSize: 12,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // const SizedBox(height: 10),

            // Text(group["description"], maxLines: 3),

            // const SizedBox(height: 10),

            // Text("${group["members"]} Members"),
          ],
        ),
      ),
    );
  }
}
