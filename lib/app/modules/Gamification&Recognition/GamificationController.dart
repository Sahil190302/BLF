


import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class GamificationController extends GetxController {
  var totalPoints = 320.obs;
  var referralPoints = 120.obs;
  var tyfcbPoints = 100.obs;
  var oneToOnePoints = 100.obs;

  var leaderboard = <LeaderboardMember>[].obs;
  var badges = <Badge>[].obs;
  var certificates = <Certificate>[].obs;

  @override
  void onInit() {
    super.onInit();

    // Dummy leaderboard data
    leaderboard.addAll([
      LeaderboardMember(name: "John Doe", points: 450),
      LeaderboardMember(name: "Aryan Kumawat", points: 400),
      LeaderboardMember(name: "Jane Smith", points: 350),
      LeaderboardMember(name: "Robert Lee", points: 300),
    ]);

    // Dummy badges
    badges.addAll([
      Badge(name: "Top Referrer", imageUrl: "https://img.icons8.com/color/48/000000/medal.png"),
      Badge(name: "Networking Star", imageUrl: "https://img.icons8.com/color/48/000000/star.png"),
      Badge(name: "TYFCB Champion", imageUrl: "https://img.icons8.com/color/48/000000/trophy.png"),
    ]);

    // Dummy certificates
    certificates.addAll([
      Certificate(title: "Referral Champion", date: "Dec 2025"),
      Certificate(title: "Best Networking", date: "Nov 2025"),
    ]);
  }
}

// ============================ Models ============================

class LeaderboardMember {
  String name;
  int points;

  LeaderboardMember({required this.name, required this.points});
}

class Badge {
  String name;
  String imageUrl;

  Badge({required this.name, required this.imageUrl});
}

class Certificate {
  String title;
  String date;

  Certificate({required this.title, required this.date});
}
