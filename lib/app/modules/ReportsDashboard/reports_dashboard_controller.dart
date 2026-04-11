import 'package:get/get.dart';

// For chart data
class PerformanceData {
  final String month;
  final int value;
  PerformanceData(this.month, this.value);
}

class AdminStat {
  final String title;
  final String details;
  AdminStat({required this.title, required this.details});
}

class ReportsDashboardController extends GetxController {
  var isLoading = true.obs;

  // Member chart data
  var memberData = <PerformanceData>[].obs;

  // Summary data
  var totalVisitors = 0.obs;
  var totalMeetings = 0.obs;
  var conversionRate = 0.0.obs;

  // Admin data
  var chapterStats = <AdminStat>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDummyData();
  }

  void loadDummyData() async {
    await Future.delayed(const Duration(seconds: 1)); // simulate API
    memberData.value = [
      PerformanceData("Jan", 5),
      PerformanceData("Feb", 8),
      PerformanceData("Mar", 6),
      PerformanceData("Apr", 10),
      PerformanceData("May", 7),
    ];
    totalVisitors.value = 36;
    totalMeetings.value = 12;
    conversionRate.value = 33.3;

    chapterStats.value = [
      AdminStat(title: "Total Members", details: "50 members in this chapter"),
      AdminStat(title: "Total Visitors", details: "400 visitors tracked"),
      AdminStat(title: "Meeting Attendance", details: "Average 75% attendance"),
    ];

    isLoading.value = false;
  }

  void exportReport() {
    // TODO: implement PDF/Excel export
    Get.snackbar("Export", "Export to PDF/Excel feature coming soon!");
  }
}
