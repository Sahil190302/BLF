import 'package:blf/app/modules/Gallery/full_screen_media.dart';
import 'package:blf/app/modules/Gallery/galley_controller.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_button.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({super.key});

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> {
  final GalleryController controller = Get.put(GalleryController());

  @override
  void initState() {
    super.initState();
    controller.loadMyGallery();
    controller.loadUsersGallery();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: "Gallery", showBackButton: true),
        body: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 6),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: Colors.grey.shade200,
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(26),
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark, AppColors.primary],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.15),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey.shade700,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: GoogleFonts.kumbhSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                unselectedLabelStyle: GoogleFonts.kumbhSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: const [
                  Tab(text: "My Gallery"),
                  Tab(text: "Members Gallery"),
                ],
              ),
            ),
            const Expanded(
              child: TabBarView(
                children: [_MyGalleryTab(), _UsersGalleryTab()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MyGalleryTab extends GetView<GalleryController> {
  const _MyGalleryTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Upload Area
          GestureDetector(
            onTap: controller.pickFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.primaryDark),
                color: AppColors.primary.withOpacity(.1),
              ),
              child: Column(
                children: [
                  const Icon(Icons.cloud_upload_rounded, size: 46),
                  const SizedBox(height: 10),
                  Text(
                    "Tap to upload photos or videos",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Selected File Preview
          Obx(() {
            if (controller.selectedFile.value == null) {
              return const SizedBox();
            }

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.insert_drive_file),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      controller.selectedFile.value!.path.split("/").last,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  GestureDetector(
                    onTap: () {
                      controller.selectedFile.value = null;
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          /// Upload Button directly below
          CustomButton(text: "Upload", onTap: controller.submitGallery),

          const SizedBox(height: 18),

          /// Gallery Title
          Text(
            "My Media",
            style: GoogleFonts.kumbhSans(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 10),

          /// Gallery Grid
          Expanded(
            child: Obx(() {
              if (controller.myGallery.isEmpty) {
                return const Center(child: Text("No Media"));
              }

              return GridView.builder(
                itemCount: controller.myGallery.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemBuilder: (_, index) {
                  final fileUrl = controller.myGallery[index]['file'];

                  bool isVideo =
                      fileUrl.endsWith(".mp4") ||
                      fileUrl.endsWith(".mov") ||
                      fileUrl.endsWith(".avi") ||
                      fileUrl.endsWith(".mkv");

                  return GestureDetector(
                    onTap: () {
                      Get.to(() => FullScreenMedia(url: fileUrl));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          /// Image
                          if (!isVideo)
                            Image.network(
                              fileUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),

                          /// Video Gradient Overlay
                          if (isVideo)
                            Container(
                              width: double.infinity,
                              height: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.black.withOpacity(.2),
                                    Colors.black.withOpacity(.6),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),

                          /// Play Button
                          if (isVideo)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.black,
                                  size: 32,
                                ),
                              ),
                            ),

                          /// Video Badge
                          if (isVideo)
                            Positioned(
                              bottom: 6,
                              right: 6,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  "VIDEO",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _UsersGalleryTab extends GetView<GalleryController> {
  const _UsersGalleryTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Obx(() {
        if (controller.usersGallery.isEmpty) {
          return const Center(child: Text("No Media"));
        }

        return GridView.builder(
          itemCount: controller.usersGallery.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (_, index) {
            final fileUrl = controller.usersGallery[index]['file'];

            bool isVideo =
                fileUrl.endsWith(".mp4") ||
                fileUrl.endsWith(".mov") ||
                fileUrl.endsWith(".avi") ||
                fileUrl.endsWith(".mkv");

            return GestureDetector(
              onTap: () {
                Get.to(() => FullScreenMedia(url: fileUrl));
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    /// Image
                    if (!isVideo)
                      Image.network(
                        fileUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),

                    /// Video Thumbnail
                    if (isVideo)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black.withOpacity(.2),
                              Colors.black.withOpacity(.6),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ),

                    /// Play Icon
                    if (isVideo)
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(.9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.black,
                            size: 32,
                          ),
                        ),
                      ),

                    /// Video Label
                    if (isVideo)
                      Positioned(
                        bottom: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(.7),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            "VIDEO",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
