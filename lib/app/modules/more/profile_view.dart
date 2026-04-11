import 'dart:io';

import 'package:blf/app/modules/more/UpdateUsernamePasswordPage.dart';
import 'package:blf/app/modules/more/Update_Bio_Page.dart';
import 'package:blf/app/modules/more/my_business_about_page.dart';
import 'package:blf/app/modules/more/update_address_page.dart';
import 'package:blf/app/modules/more/update_contact_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/widgets/custom_appbar.dart';
import '../../../../utils/app_colors.dart';
import 'profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "PROFILE"),

      body: Obx(
        () => SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              /// ------------------------------------- -------------------
              /// PROFILE HEADER (UPDATED + VERIFIED + DUE DATE)
              /// --------------------------------------------------------
              // Replace the existing Center(...) with this Container + child
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryDark.withOpacity(0.9), // Dark Gre// en
                      AppColors.green.withOpacity(0.9), // Dark Green
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // IMAGE + VERIFIED BADGE
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.grey[200]!,
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: controller.profileImage.value.isEmpty
                                ? const Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                : controller.profileImage.value.startsWith(
                                    "http",
                                  )
                                ? CachedNetworkImage(
                                    imageUrl: controller.profileImage.value,
                                    fit: BoxFit.cover,
                                    progressIndicatorBuilder:
                                        (context, url, progress) => Center(
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
                                    errorWidget: (context, url, error) =>
                                        const Icon(
                                          Icons.person,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                  )
                                : Image.file(
                                    File(controller.profileImage.value),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),

                        /// VERIFIED BADGE
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.verified_rounded,
                              color: Colors.blue,
                              size: 20,
                            ),
                          ),
                        ),

                        /// EDIT BUTTON
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.pickProfileImage();
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryDark,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // NAME
                    Text(
                      controller.name.value,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.white, // white text on gradient
                      ),
                    ),

                    // CATEGORY
                    Text(
                      controller.category.value,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 14,
                        color: AppColors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    // const SizedBox(height: 5),

                    // // DUE DATE
                    // Text(
                    //   "Due: ${controller.dueDate.value}",
                    //   style: GoogleFonts.kumbhSans(
                    //     fontSize: 13,
                    //     color: AppColors.white.withOpacity(0.9),
                    //     fontWeight: FontWeight.w600,
                    //   ),
                    // ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              /// --------------------------------------------------------
              /// DETAILS CARD
              /// --------------------------------------------------------
              // Container(
              //   padding: const EdgeInsets.all(16),
              //   decoration: BoxDecoration(
              //     color: AppColors.white,
              //     borderRadius: BorderRadius.circular(14),
              //     boxShadow: [
              //       BoxShadow(
              //         color: AppColors.lightGrey.withOpacity(0.35),
              //         blurRadius: 10,
              //         offset: const Offset(0, 3),
              //       ),
              //     ],
              //   ),
              //   // child: Column(
              //   //   children: [
              //   //     _infoRow(
              //   //       "Due Date",
              //   //       controller.dueDate.value,
              //   //       Icons.calendar_month,
              //   //     ),
              //   //     const SizedBox(height: 14),
              //   //     _infoRow(
              //   //       "Classification",
              //   //       controller.classification.value,
              //   //       Icons.badge,
              //   //     ),
              //   //   ],
              //   // ),
              // ),
              const SizedBox(height: 5),

              /// --------------------------------------------------------
              /// ALL PROFILE ACTION BUTTONS
              /// --------------------------------------------------------
              // _primaryButton("Share My Profile", Icons.share, () {}),
              // _primaryButton("My Community", Icons.diversity_3, () {

              //   Get.to(()=>CommunityPage());
              // }),

              // _primaryButton("My Network", Icons.people_alt, () {}),
              _primaryButton("My Business", Icons.store, () {
                Get.to(() => MyBusinessAboutPage());
              }),
              _primaryButton("Address", Icons.location_on, () {
                Get.to(() => UpdateAddressPage());
              }),
              _primaryButton("Contact", Icons.phone, () {
                Get.to(() => UpdateContactPage());
              }),
              _primaryButton("My Bio", Icons.description, () {
                Get.to(() => UpdateBioPage());
              }),

              _primaryButton("Update Username / Password", Icons.lock, () {
                Get.to(() => UpdateUsernamePasswordPage());
              }),
            ],
          ),
        ),
      ),
    );
  }

  // --------------------------------------------------------------------
  // REUSABLE INFO ROW
  // --------------------------------------------------------------------
  Widget _infoRow(String title, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: AppColors.primaryDark, size: 20),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.kumbhSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: GoogleFonts.kumbhSans(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --------------------------------------------------------------------
  // PRIMARY BUTTON
  // --------------------------------------------------------------------
  Widget _primaryButton(String text, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightGrey.withOpacity(0.25),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryDark, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.kumbhSans(
                  color: AppColors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: AppColors.primaryDark,
            ),
          ],
        ),
      ),
    );
  }
}
