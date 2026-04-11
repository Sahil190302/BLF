// announcements_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Announcement {
  String title;
  String description;
  String? imageUrl;
  int likes;
  List<String> comments;

  Announcement({
    required this.title,
    required this.description,
    this.imageUrl,
    this.likes = 0,
    List<String>? comments,
  }) : comments = comments ?? [];
}

class AnnouncementsController extends GetxController {
  var announcements = <Announcement>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    announcements.addAll([
      Announcement(
        title: "Welcome to Our Community!",
        description: "We are excited to have you here. Stay tuned for upcoming events and updates.",
        imageUrl: "https://picsum.photos/300/150", // sample image
        likes: 10,
        comments: ["Great news!", "Looking forward to it!"],
      ),
      Announcement(
        title: "Monthly Meetup Scheduled",
        description: "Our next monthly meetup will be on 20th December at 6 PM. Don't miss it!",
        imageUrl: "https://picsum.photos/300/151",
        likes: 7,
        comments: ["I will be there.", "Can't wait!"],
      ),
      Announcement(
        title: "New Training Program",
        description: "Enroll in our new business training program starting next week. Limited seats available.",
        imageUrl: null, // no image
        likes: 5,
        comments: ["Sounds useful!", "Sign me up!"],
      ),
    ]);
  }

  void addAnnouncement(Announcement announcement) {
    announcements.add(announcement);
  }

  void likeAnnouncement(int index) {
    announcements[index].likes += 1;
    announcements.refresh();
  }

  void addComment(int index, String comment) {
    announcements[index].comments.add(comment);
    announcements.refresh();
  }
}
