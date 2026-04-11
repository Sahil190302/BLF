import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:blf/app/modules/Community/Groups/group_post_api.dart';
import 'package:blf/app/modules/Community/Groups/participants_api.dart';
import 'package:blf/app/services/home_api.dart';

class GroupDetailsController extends GetxController {
  RxMap<String, dynamic> group = <String, dynamic>{}.obs;

  final posts = <Map<String, dynamic>>[].obs;
  final participants = <Map<String, dynamic>>[].obs;
  final comments = <Map<String, dynamic>>[].obs;
  final isCommentsLoading = false.obs;
  final isPostsLoading = true.obs;
  final searchQuery = "".obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      group.value = Map<String, dynamic>.from(Get.arguments);
    }

    loadPosts();

    super.onInit();
  }

  int get groupId => int.parse(group["sno"].toString());

  // ---------------------------------------------------
  // POSTS
  // ---------------------------------------------------
  Future<void> loadPosts() async {
    try {
      isPostsLoading.value = true;

      final data = await GroupPostApi.fetchPosts(groupId);

      posts.assignAll(data);
    } finally {
      isPostsLoading.value = false;
    }
  }

  Future<void> addPost(String title, String detail) async {
    final user = await HomeApi.fetchUser();
    final userId = int.parse(user["sno"].toString());

    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final success = await GroupPostApi.addPost(
      groupId: groupId,
      userId: userId,
      title: title,
      detail: detail,
      date: today,
    );

    if (success) {
      if (Get.isDialogOpen ?? false) {
        Get.back(); // closes Add Post dialog
      }

      await loadPosts();

      Future.delayed(const Duration(milliseconds: 200), () {
        final context = Get.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Post added successfully")),
          );
        }
      });
    }
  }

  // ---------------------------------------------------
  // COMMENTS
  // ---------------------------------------------------
  Future<void> loadComments(int postId) async {
    try {
      isCommentsLoading.value = true;

      comments.clear();

      final data = await GroupPostApi.fetchComments(postId);

      comments.assignAll(data);
    } finally {
      isCommentsLoading.value = false;
    }
  }

  Future<void> addComment(int postId, String comment) async {
    final user = await HomeApi.fetchUser();
    final userId = int.parse(user["sno"].toString());

    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final success = await GroupPostApi.addComment(
      postId: postId,
      userId: userId,
      comment: comment,
      date: today,
    );

    if (success) {
      if (Get.context != null) {
        Navigator.of(Get.context!).pop();
      }

      await loadComments(postId);

      Future.delayed(const Duration(milliseconds: 200), () {
        final context = Get.context;
        if (context != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Comment added successfully")),
          );
        }
      });
    }
  }

  // ---------------------------------------------------
  // PARTICIPANTS
  // ---------------------------------------------------
  Future<void> openParticipants() async {
    final data = await ParticipantsApi.fetchParticipants(groupId);

    participants.assignAll(data);
  }

  // ---------------------------------------------------
  // SEARCH
  // ---------------------------------------------------
  List<Map<String, dynamic>> get filteredPosts {
    if (searchQuery.value.isEmpty) return posts;

    final q = searchQuery.value.toLowerCase();

    return posts.where((p) {
      final title = (p["title"] ?? "").toString().toLowerCase();
      final content = (p["content"] ?? "").toString().toLowerCase();

      return title.contains(q) || content.contains(q);
    }).toList();
  }

  void joinGroup() {
    Get.snackbar("Success", "You have joined the group!");
  }
}
