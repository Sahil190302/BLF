import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'group_details_controller.dart';

class GroupDetailsView extends StatelessWidget {
  final GroupDetailsController controller = Get.put(GroupDetailsController());
  RxBool isCommentsLoading = false.obs;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(
        title: controller.group["name"] ?? "Group Details",
        showBackButton: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _topGroupCard(),
              const SizedBox(height: 20),
              _searchAndSort(),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.isCommentsLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return const SizedBox();
              }),

              Obx(() {
                if (controller.isPostsLoading.value) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (controller.filteredPosts.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                    child: Center(child: Text("No posts available")),
                  );
                }

                return Column(
                  children: controller.filteredPosts
                      .map((post) => _postCard(post))
                      .toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------------------------------------
  //                    TOP GROUP CARD
  // ----------------------------------------------------------
  Widget _topGroupCard() {
    var group = controller.group;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 7,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  group["icon"],
                  height: 70,
                  width: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (c, o, s) =>
                      Icon(Icons.group, size: 70, color: Colors.grey),
                ),
              ),

              SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      group["name"],
                      style: GoogleFonts.kumbhSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),

                    SizedBox(height: 4),

                    Text(
                      "Since : ${group["since"]}",
                      style: GoogleFonts.kumbhSans(
                        color: Colors.black54,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16),

          Text(
            "Description",
            style: GoogleFonts.kumbhSans(
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),

          SizedBox(height: 6),

          Text(
            group["description"],
            style: GoogleFonts.kumbhSans(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),

          SizedBox(height: 20),

          // -----------------------------
          //  ACTION BUTTONS
          // -----------------------------
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    await controller.openParticipants();

                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          "Participants",
                          style: GoogleFonts.kumbhSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: SizedBox(
                          width: double.maxFinite,
                          child: Obx(
                            () => controller.participants.isEmpty
                                ? const Center(
                                    child: Text("No participants found"),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: controller.participants.length,
                                    itemBuilder: (context, index) {
                                      final p = controller.participants[index];

                                      return Container(
                                        margin: const EdgeInsets.only(
                                          bottom: 10,
                                        ),
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.05,
                                              ),
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: Row(
                                          children: [
                                            p["image"] == ""
                                                ? const CircleAvatar(
                                                    radius: 22,
                                                    child: Icon(Icons.person),
                                                  )
                                                : CircleAvatar(
                                                    radius: 22,
                                                    backgroundImage:
                                                        NetworkImage(
                                                          p["image"],
                                                        ),
                                                  ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                p["name"],
                                                style: GoogleFonts.kumbhSans(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              if (Get.context != null) {
                                Navigator.of(Get.context!).pop();
                              }
                            },
                            child: Text(
                              "Close",
                              style: GoogleFonts.kumbhSans(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary, width: 1.3),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Participants",
                    style: GoogleFonts.kumbhSans(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: GestureDetector(
                  onTap: () {
                    final titleController = TextEditingController();
                    final detailController = TextEditingController();

                    Get.dialog(
                      AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        title: Text(
                          "Add Post",
                          style: GoogleFonts.kumbhSans(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextField(
                              controller: titleController,
                              decoration: const InputDecoration(
                                labelText: "Title",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: detailController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                labelText: "Detail",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(Get.context!).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              controller.addPost(
                                titleController.text,
                                detailController.text,
                              );
                            },
                            child: const Text("Post"),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Container(
                    height: 46,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey.shade100,
                      border: Border.all(color: Colors.grey.shade400),
                    ),
                    child: Center(
                      child: Text(
                        "Add Post",
                        style: GoogleFonts.kumbhSans(
                          color: Colors.black87,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //                    SEARCH + SORT
  // ----------------------------------------------------------
  Widget _searchAndSort() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Search and Sort By",
          style: GoogleFonts.kumbhSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                height: 46,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: TextField(
                  onChanged: (v) =>
                      controller.searchQuery.value = v.toLowerCase(),
                  decoration: InputDecoration(
                    hintText: "Search Title, Description or Topics",
                    border: InputBorder.none,
                    hintStyle: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            _iconBtn(Icons.search),
            const SizedBox(width: 10),
            _iconBtn(Icons.filter_list),
          ],
        ),
      ],
    );
  }

  Widget _iconBtn(IconData icon) {
    return Container(
      height: 46,
      width: 46,
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

  // ----------------------------------------------------------
  //                   POST CARD
  // ----------------------------------------------------------
  Widget _postCard(Map<String, dynamic> post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              post["image"] == ""
                  ? const CircleAvatar(radius: 22, child: Icon(Icons.person))
                  : CircleAvatar(
                      radius: 22,
                      backgroundImage: NetworkImage(post["image"]),
                    ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  post["title"],
                  style: GoogleFonts.kumbhSans(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Posted By ",
                  style: GoogleFonts.kumbhSans(
                    color: Colors.black,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: post["postedBy"],
                  style: GoogleFonts.kumbhSans(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            post["date"],
            style: GoogleFonts.kumbhSans(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          Text(
            post["content"],
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.kumbhSans(fontSize: 13),
          ),
          const SizedBox(height: 12),
          Text(
            "Read More",
            style: GoogleFonts.kumbhSans(
              fontSize: 13,
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () async {
                  await controller.loadComments(post["sno"]);

                  final commentController = TextEditingController();

                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      title: Text(
                        "Comments",
                        style: GoogleFonts.kumbhSans(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      content: SizedBox(
                        width: double.maxFinite,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Obx(() {
                              if (controller.isCommentsLoading.value) {
                                return const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  child: Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              if (controller.comments.isEmpty) {
                                return const Padding(
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Text("No comments yet"),
                                );
                              }

                              return SizedBox(
                                height: 220,
                                child: ListView.builder(
                                  itemCount: controller.comments.length,
                                  itemBuilder: (context, i) {
                                    final c = controller.comments[i];

                                    return ListTile(
                                      leading: c["image"] == ""
                                          ? const CircleAvatar(
                                              child: Icon(Icons.person),
                                            )
                                          : CircleAvatar(
                                              backgroundImage: NetworkImage(
                                                c["image"],
                                              ),
                                            ),
                                      title: Text(c["name"]),
                                      subtitle: Text(c["comment"]),
                                    );
                                  },
                                ),
                              );
                            }),

                            const SizedBox(height: 10),

                            TextField(
                              controller: commentController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                hintText: "Write a comment...",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(Get.context!).pop();
                          },
                          child: const Text("Close"),
                        ),

                        ElevatedButton(
                          onPressed: () {
                            controller.addComment(
                              post["sno"],
                              commentController.text,
                            );
                          },
                          child: const Text("Post"),
                        ),
                      ],
                    ),
                  );
                },
                child: Row(
                  children: [
                    const Icon(Icons.comment, size: 17, color: Colors.grey),
                    const SizedBox(width: 5),
                    Text(
                      "${post["comments"]} Comments",
                      style: GoogleFonts.kumbhSans(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
