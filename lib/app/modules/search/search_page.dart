import 'package:blf/app/modules/Community/Connections/connection_profile_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/app/modules/search/search_model.dart';
import 'package:blf/widgets/custom_appbar.dart';
import '../../../utils/app_colors.dart';
import 'search_controller.dart';

class SearchPageView extends StatelessWidget {
  const SearchPageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(search_controller());

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "SEARCH"),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12),
              ),
              child: TextField(
                style: GoogleFonts.kumbhSans(
                  color: Colors.black87,
                  fontSize: 16,
                ),
                onChanged: (v) => controller.query.value = v,
                decoration: InputDecoration(
                  hintText: "Search by name, category or business name",
                  border: InputBorder.none,
                  hintStyle: GoogleFonts.kumbhSans(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  icon: Icon(Icons.search, color: AppColors.primaryDark),
                ),
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              var list = controller.searchFilteredList();

              if (list.isEmpty) {
                return _buildEmptyState();
              }

              return ListView.separated(
                padding: const EdgeInsets.all(15),
                itemCount: list.length,
                physics: const BouncingScrollPhysics(),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  var user = list[index];
                  return _buildUserCard(user);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(SearchUser user) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ConnectionProfileView(user: user));
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primaryDark, width: 3),
              ),
              child: ClipOval(
                child: CachedNetworkImage(
                  imageUrl: user.image.isEmpty
                      ? "https://via.placeholder.com/150"
                      : user.image,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, progress) => Center(
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        strokeWidth: 1,
                        value: progress.progress,
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 40,
                    color: AppColors.primaryDark,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 15),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    user.category,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.chevron_right_rounded,
              size: 28,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 60,
            color: AppColors.textSecondary.withOpacity(0.3),
          ),
          const SizedBox(height: 15),
          Text(
            "No Results Found",
            style: GoogleFonts.kumbhSans(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Try searching by name",
            style: GoogleFonts.kumbhSans(
              fontSize: 14,
              color: AppColors.textSecondary.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
