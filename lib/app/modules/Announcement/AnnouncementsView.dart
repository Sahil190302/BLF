import 'package:blf/app/modules/Announcement/AnnouncementsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';

class AnnouncementsView extends StatelessWidget {
  AnnouncementsView({super.key});

  final AnnouncementsController controller = Get.put(AnnouncementsController());
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Announcements & Communication",
        showBackButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Obx(
              () => ListView.builder(
            itemCount: controller.announcements.length,
            itemBuilder: (context, index) {
              final announcement = controller.announcements[index];
              return _announcementCard(index, announcement);
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.white,
        ),
        onPressed: () => _showAddAnnouncementDialog(context),
      ),
    );
  }

  Widget _announcementCard(int index, Announcement announcement) {
    return Card(
      color: Colors.white, // white card
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              announcement.title,
              style: GoogleFonts.kumbhSans(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryDark,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              announcement.description,
              style: GoogleFonts.kumbhSans(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
            if (announcement.imageUrl != null) ...[
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  announcement.imageUrl!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  loadingBuilder: (BuildContext context, Widget child,
                      ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          color: AppColors.primary,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(
                        child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                      ),
                    );
                  },
                ),
              ),
            ],

            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  onPressed: () => controller.likeAnnouncement(index),
                  icon: Icon(Icons.thumb_up, color: AppColors.primary),
                ),
                Text(
                  '${announcement.likes}',
                  style: GoogleFonts.kumbhSans(fontSize: 14),
                ),
                const SizedBox(width: 20),
                IconButton(
                  onPressed: () => _showAddCommentDialog(index),
                  icon: Icon(Icons.comment, color: AppColors.primary),
                ),
                Text(
                  '${announcement.comments.length}',
                  style: GoogleFonts.kumbhSans(fontSize: 14),
                ),
              ],
            ),
            if (announcement.comments.isNotEmpty) ...[
              const Divider(),
              ...announcement.comments.map((c) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  c,
                  style: GoogleFonts.kumbhSans(
                    fontSize: 13,
                    color: Colors.grey[700],
                  ),
                ),
              )),
            ]
          ],
        ),
      ),
    );
  }

  void _showAddAnnouncementDialog(BuildContext context) {
    final TextEditingController titleCtrl = TextEditingController();
    final TextEditingController descCtrl = TextEditingController();
    final TextEditingController imageCtrl = TextEditingController();

    Get.defaultDialog(
      title: "Add Announcement",


      titleStyle: GoogleFonts.kumbhSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      ),
      content: Column(
        children: [
          TextField(
            controller: titleCtrl,
            style: GoogleFonts.kumbhSans(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Enter title",
              hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[500], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descCtrl,
            style: GoogleFonts.kumbhSans(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Enter description",
              hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[500], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: imageCtrl,
            style: GoogleFonts.kumbhSans(fontSize: 14, color: Colors.black87),
            decoration: InputDecoration(
              hintText: "Image URL (optional)",
              hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[500], fontSize: 14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
      confirm: CustomButton(
        text: "Add",
        onTap: () {
          controller.addAnnouncement(
            Announcement(
              title: titleCtrl.text,
              description: descCtrl.text,
              imageUrl: imageCtrl.text.isEmpty ? null : imageCtrl.text,
            ),
          );
          Get.back();
        },
      ),
      cancel: CustomButton(
        text: "Cancel",
        onTap: () => Get.back(),
      ),
    );
  }

  void _showAddCommentDialog(int index) {
    commentController.clear();
    Get.defaultDialog(
      title: "Add Comment",
      titleStyle: GoogleFonts.kumbhSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: AppColors.primaryDark,
      ),
      content: TextField(
        controller: commentController,
        style: GoogleFonts.kumbhSans(fontSize: 14, color: Colors.black87),
        decoration: InputDecoration(
          hintText: "Write a comment",
          hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[500], fontSize: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      confirm: CustomButton(
        text: "Add",
        onTap: () {
          if (commentController.text.isNotEmpty) {
            controller.addComment(index, commentController.text);
          }
          Get.back();
        },
      ),
      cancel: CustomButton(
        text: "Cancel",
        onTap: () => Get.back(),
      ),
    );
  }

}
