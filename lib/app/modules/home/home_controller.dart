import 'dart:async';
import 'package:blf/app/services/app_session.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController with WidgetsBindingObserver {
  /// ───────────────── HEADER INFO ─────────────────
  var userName = ''.obs;
  var company = ''.obs;
  var status = 'Active'.obs;
  var dueDate = 'Due Date: 04/01/2021'.obs;
  var selectedPeriod = '3 Months'.obs;
  RxString profileImageUrl = ''.obs;
  Timer? autoRefreshTimer;

  /// 📅 MEETING DATA
  RxString nextMeeting = ''.obs;
  RxString meetingPlace = ''.obs;

  RxList<Map<String, dynamic>> meetingNotifications =
      <Map<String, dynamic>>[].obs;

  /// ✅ ATTENDANCE STATE
  RxString attendanceStatus = ''.obs; // present / absent
  RxBool showReasonField = false.obs;

  /// 📝 ABSENT REASON
  TextEditingController absentReasonController = TextEditingController();

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      autoRefreshTimer?.cancel();
    } else if (state == AppLifecycleState.resumed) {
      startAutoRefresh();
      refreshHome(); // ADD THIS
    }
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    autoRefreshTimer?.cancel();
    absentReasonController.dispose();
    super.onClose();
  }

  void controllerUpdateSlips(Map<String, dynamic> data) {
    slips[0]['displayValue'].value =
        (data["thankyou"]?["given_Thankyou_count"] ?? 0).toString();

    slips[1]['displayValue'].value =
        ((data["referral"]?["inside_count"] ?? 0) +
                (data["referral"]?["outside_count"] ?? 0))
            .toString();

    slips[2]['displayValue'].value = (data["person_to_person_count"] ?? 0)
        .toString();

    slips[3]['displayValue'].value = "0"; // testimonials not provided

    slips[4]['displayValue'].value = (data["visitor_count"] ?? 0).toString();
  }

  void startAutoRefresh() {
    autoRefreshTimer?.cancel();

    autoRefreshTimer = Timer.periodic(const Duration(seconds: 5), (
      timer,
    ) async {
      if (isRefreshing) return;

      isRefreshing = true;
      try {
        await refreshHome();
      } catch (_) {}
      isRefreshing = false;
    });
  }

  Future<void> loadMonthlyDashboard(int months) async {
    try {
      if (userSno.value.isEmpty) return;

      final data = await HomeApi.fetchMonthlyDashboard(
        sno: userSno.value,
        periodMonths: months,
      );

      updateAllDashboardValues(data);
    } catch (e) {
      Get.snackbar("Error", "Unable to load data");
    }
  }

  Future<void> markAttendance({
    required int sno,
    required String status,
    required String attend,
  }) async {
    final success = await HomeApi.updateAttendance(
      sno: sno,
      status: status,
      attend: attend,
    );

    if (success) {
      // Remove that meeting from list (since attend_status is no longer "")
      meetingNotifications.removeWhere((item) => item["sno"] == sno);
    }
  }

  Future<void> loadTodayMeetingNotification() async {
    if (userSno.value.isEmpty) return;

    final data = await HomeApi.fetchTodayMeetingNotification(
      userId: userSno.value,
    );

    meetingNotifications.value = data;
  }

  Future<void> loadHomeData() async {
    try {
      final userData = await HomeApi.fetchUser();

      userName.value = userData["name"] ?? "";
      company.value = userData["business_name"] ?? "";
      status.value = userData["status"] == 1 ? "Active" : "Inactive";

      nextMeeting.value = userData["date"] ?? "";
      meetingPlace.value = userData["business_address"] ?? "";

      userSno.value = userData["sno"].toString();
      await loadTodayMeetingNotification();

      final String baseUrl =
          "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/";
      final String imagePath = userData["profile_image"] ?? "";

      if (imagePath.isNotEmpty) {
        profileImageUrl.value = baseUrl + imagePath.replaceAll("../", "");
      }

      /// DASHBOARD API
      final dashboard = await HomeApi.fetchDashboard(
        userData["sno"].toString(),
      );

      final int meetingTotal = dashboard["meeting"]?["total"] ?? 0;

      final int referralReceived = dashboard["referral"]?["received"] ?? 0;

      final double totalAmount = (dashboard["thankyou"]?["total_amount"] ?? 0)
          .toDouble();

      final int givenThankyouCount =
          dashboard["thankyou"]?["given_Thankyou_count"] ?? 0;

      final int recieveThankyouCount =
          dashboard["thankyou"]?["received_Thankyou_count"] ?? 0;

      final int referralGiven = dashboard["referral"]?["given"] ?? 0;

      /// HEADER
      meetingsCount.value = meetingTotal;
      referralsCount.value = referralReceived;
      revenueCount.value = totalAmount;

      dashboardReferralGiven.value = referralGiven;
      dashboardReferralReceived.value = referralReceived;

      /// GRID (replace all with meeting total as requested)
      thankYouGivenCount.value = givenThankyouCount;
      thankYouReceivedCount.value = recieveThankyouCount;
      outsideReferralCount.value = referralGiven;
      insideReferralCount.value = referralReceived;
      p2pMeetingCount.value = meetingTotal;
    } catch (e) {
      debugPrint("API Error: $e");
    }
  }

  /// ✅ PRESENT CLICK
  void markPresent() {
    attendanceStatus.value = 'present';
    showReasonField.value = false;
  }

  /// ❌ ABSENT CLICK
  void markAbsent() {
    showReasonField.value = true;
    attendanceStatus.value = ''; // keep empty until submit
  }

  /// 📤 SUBMIT
  /// 📩 SUBMIT ABSENT
  void submitAttendance() {
    if (absentReasonController.text.trim().isEmpty) {
      Get.snackbar(
        'Reason required',
        'Please enter a reason for absence',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    attendanceStatus.value = 'absent';
    showReasonField.value = false;

    /// optional: clear text
    // absentReasonController.clear();
  }

  List<String> periods = ['3 Months', '6 Months', '12 Months'];

  /// ───────────────── MAIN COUNTS ─────────────────
  var meetingsCount = 0.obs;
  var referralsCount = 0.obs;
  var revenueCount = 0.0.obs;

  /// ───────────────── QUICK STATS ─────────────────
  var tyfcbCount = 0.obs;
  var visitorsCount = 0.obs;
  var speakersCount = 0.obs;
  RxString userSno = ''.obs;
  RxBool isPeriodMode = true.obs; // true = 3/6/12 mode, false = dropdown mode
  bool isRefreshing = false;

  /// ───────────────── THANK YOU STATS ─────────────────
  var thankYouGivenAmount = 0.0.obs;
  var thankYouGivenCount = 0.obs;

  var thankYouReceivedAmount = 0.0.obs;
  var thankYouReceivedCount = 0.obs;

  var ReferralGiven = 0.obs;
  var ReferralRecieved = 0.obs;

  /// ───────────────── REFERRALS & P2P ─────────────────
  var outsideReferralCount = 0.obs;
  var insideReferralCount = 0.obs;
  var p2pMeetingCount = 0.obs;

  var dashboardReferralGiven = 0.obs;
  var dashboardReferralReceived = 0.obs;

  // Month & Date filters
  // Month filter
  RxnString selectedMonth = RxnString(); // null by default

  List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  /// ───────────────── UPCOMING EVENTS ─────────────────
  RxList<Map<String, dynamic>> upcomingEvents = <Map<String, dynamic>>[].obs;

  /// ───────────────── STATS GRID DATA ─────────────────
  var stats = <Map<String, dynamic>>[
    {
      'title': 'Person to Person (P2P)',
      'type': 'number',
      'displayValue': '0'.obs,
    },
    {'title': 'Outside Referrals', 'type': 'number', 'displayValue': '0'.obs},
    {'title': 'Inside Referrals', 'type': 'number', 'displayValue': '0'.obs},
    {
      'title': 'Business Acknowledgement Given',
      'type': 'number',
      'displayValue': '0'.obs,
    },
    {
      'title': 'Business Acknowledgement Given (Amount)',
      'type': 'amount',
      'displayValue': '0'.obs,
    },
    {
      'title': 'Business Acknowledgement Received',
      'type': 'number',
      'displayValue': '0'.obs,
    },
    {
      'title': 'Business Acknowledgement Received (Amount)',
      'type': 'amount',
      'displayValue': '0'.obs,
    },
    {'title': 'Visitors', 'type': 'number', 'displayValue': '0'.obs},
  ].obs;
  var slips = <Map<String, dynamic>>[
    {'title': 'Business Acknowledgement', 'value': 5, 'displayValue': '0'.obs},
    {'title': 'Referrals', 'value': 8, 'displayValue': '0'.obs},
    {'title': 'Person to Person (P2P)', 'value': 3, 'displayValue': '0'.obs},
    {'title': 'Events', 'value': 6, 'displayValue': '0'.obs},
    {'title': 'Visitors', 'value': 10, 'displayValue': '0'.obs},
  ].obs;

  /// ───────────────── FINAL TARGET VALUES ─────────────────
  final int finalMeetings = 24;
  final int finalReferrals = 12;
  final double finalRevenue = 5200.0;

  final int finalTYFCB = 5;
  final int finalVisitors = 10;
  final int finalSpeakers = 2;

  final double finalThankYouGivenAmount = 12500.0;
  final int finalThankYouGivenCount = 18;

  final double finalThankYouReceivedAmount = 9800.0;
  final int finalThankYouReceivedCount = 14;

  final int finalOutsideReferralCount = 9;
  final int finalInsideReferralCount = 21;
  final int finalP2PMeetingCount = 7;

  /// ───────────────── INIT ─────────────────
  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addObserver(this); // ADD THIS

    loadHomeData().then((_) async {
      if (userSno.value.isNotEmpty) {
        loadMonthlyDashboard(3);
      }
      await loadUpcomingEvents();
    });

    startAutoRefresh();
  }

  Future<void> loadUpcomingEvents() async {
    if (userSno.value.isEmpty) return;

    final data = await HomeApi.fetchUpcomingEvents(userId: userSno.value);

    upcomingEvents.value = data.map((event) {
      return {
        "title": event["notification_title"] ?? "",
        "date": event["notification_push_date"] ?? "",
        "icon": _getIconFromTitle(event["notification_title"] ?? ""),
      };
    }).toList();
  }

  Future<void> refreshHome() async {
    try {
      await loadHomeData();

      if (userSno.value.isNotEmpty) {
        await loadMonthlyDashboard(3);
        await loadUpcomingEvents();
      }
    } catch (_) {}
  }

  IconData _getIconFromTitle(String title) {
    final lower = title.toLowerCase();

    if (lower.contains("birthday")) return Icons.cake;
    if (lower.contains("anniversary")) return Icons.favorite;
    if (lower.contains("meeting")) return Icons.groups;
    if (lower.contains("payment")) return Icons.payments;
    if (lower.contains("project")) return Icons.work;

    return Icons.notifications;
  }

  /// ───────────────── ANIMATIONS ─────────────────
  void startAnimations() {
    animateValue(meetingsCount, finalMeetings, 1500);
    animateValue(referralsCount, finalReferrals, 1500);
    animateDoubleValue(revenueCount, finalRevenue, 1500);

    animateValue(tyfcbCount, finalTYFCB, 1200);
    animateValue(visitorsCount, finalVisitors, 1200);
    animateValue(speakersCount, finalSpeakers, 1200);

    animateDoubleValue(thankYouGivenAmount, finalThankYouGivenAmount, 1400);
    animateValue(thankYouGivenCount, finalThankYouGivenCount, 1200);

    animateDoubleValue(
      thankYouReceivedAmount,
      finalThankYouReceivedAmount,
      1400,
    );
    animateValue(thankYouReceivedCount, finalThankYouReceivedCount, 1200);

    animateValue(outsideReferralCount, finalOutsideReferralCount, 1200);
    animateValue(insideReferralCount, finalInsideReferralCount, 1200);
    animateValue(p2pMeetingCount, finalP2PMeetingCount, 1200);

    for (int i = 0; i < stats.length; i++) {
      animateObservableString(
        stats[i]['displayValue'] as RxString,
        stats[i]['value'] as int,
        1000 + (i * 150),
      );
    }
  }

  /// ───────────────── ANIMATION HELPERS ─────────────────
  void animateValue(RxInt observable, int target, int duration) {
    final steps = 30;
    final stepDuration = duration ~/ steps;
    final increment = target / steps;
    double current = 0;

    Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      current += increment;
      if (current >= target) {
        observable.value = target;
        timer.cancel();
      } else {
        observable.value = current.round();
      }
    });
  }

  void animateDoubleValue(RxDouble observable, double target, int duration) {
    final steps = 30;
    final stepDuration = duration ~/ steps;
    final increment = target / steps;
    double current = 0;

    Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      current += increment;
      if (current >= target) {
        observable.value = target;
        timer.cancel();
      } else {
        observable.value = double.parse(current.toStringAsFixed(2));
      }
    });
  }

  void animateObservableString(RxString observable, int target, int duration) {
    final steps = 30;
    final stepDuration = duration ~/ steps;
    final increment = target / steps;
    double current = 0;

    Timer.periodic(Duration(milliseconds: stepDuration), (timer) {
      current += increment;
      if (current >= target) {
        observable.value = target.toString();
        timer.cancel();
      } else {
        observable.value = current.round().toString();
      }
    });
  }

  /// ───────────────── UTILITIES ─────────────────
  String getFormattedRevenue() {
    if (revenueCount.value >= 1000) {
      return '₹${(revenueCount.value / 1000).toStringAsFixed(1)}K';
    }
    return '₹${revenueCount.value.toStringAsFixed(0)}';
  }

  void changeTimePeriod(String period) {
    selectedPeriod.value = period;
    isPeriodMode.value = true;

    // Clear month filter
    selectedMonth.value = null;

    int months = int.parse(period.split(" ")[0]);

    loadMonthlyDashboard(months);
  }

  Future<void> changeMonth(String month) async {
    selectedMonth.value = month;
    isPeriodMode.value = false;

    // Deselect period visually
    selectedPeriod.value = '';

    if (userSno.value.isEmpty) return;

    final data = await HomeApi.fetchMonthlyByMonth(
      sno: userSno.value,
      month: month,
    );

    updateAllDashboardValues(data);
  }

  void updateAllDashboardValues(Map<String, dynamic> data) {
    /// STATS LIST UPDATE

    stats[0]['displayValue'].value = (data["person_to_person_count"] ?? 0)
        .toString();

    stats[1]['displayValue'].value = (data["referral"]?["outside_count"] ?? 0)
        .toString();

    stats[2]['displayValue'].value = (data["referral"]?["inside_count"] ?? 0)
        .toString();

    stats[3]['displayValue'].value =
        (data["thankyou"]?["given_Thankyou_count"] ?? 0).toString();

    stats[4]['displayValue'].value =
        (data["thankyou"]?["given_Thankyou_total_amount"] ?? 0).toString();

    stats[5]['displayValue'].value =
        (data["thankyou"]?["received_Thankyou_count"] ?? 0).toString();

    stats[6]['displayValue'].value =
        (data["thankyou"]?["received_Thankyou_total_amount"] ?? 0).toString();

    stats[7]['displayValue'].value = (data["visitor_count"] ?? 0).toString();

    /// SLIPS
    slips[0]['displayValue'].value =
        (data["thankyou"]?["given_Thankyou_count"] ?? 0).toString();

    slips[1]['displayValue'].value =
        ((data["referral"]?["inside_count"] ?? 0) +
                (data["referral"]?["outside_count"] ?? 0))
            .toString();

    slips[2]['displayValue'].value = (data["person_to_person_count"] ?? 0)
        .toString();

    slips[3]['displayValue'].value = "0";

    slips[4]['displayValue'].value = (data["visitor_count"] ?? 0).toString();

    /// GRID
    /// GRID
    thankYouGivenCount.value = data["thankyou"]?["given_Thankyou_count"] ?? 0;

    thankYouGivenAmount.value =
        (data["thankyou"]?["given_Thankyou_total_amount"] ?? 0).toDouble();

    thankYouReceivedAmount.value =
        (data["thankyou"]?["received_Thankyou_total_amount"] ?? 0).toDouble();

    final referral = data["referral"] ?? {};

    ReferralGiven.value = data["referral"]?["outside_count"] ?? 0;
    ReferralRecieved.value = data["referral"]?["inside_count"] ?? 0;

    outsideReferralCount.value = ReferralGiven.value;
    insideReferralCount.value = ReferralRecieved.value;

    p2pMeetingCount.value = data["person_to_person_count"] ?? 0;
  }

  void resetValues() {
    meetingsCount.value = 0;
    referralsCount.value = 0;
    revenueCount.value = 0;

    tyfcbCount.value = 0;
    visitorsCount.value = 0;
    speakersCount.value = 0;

    thankYouGivenAmount.value = 0;
    thankYouGivenCount.value = 0;
    thankYouReceivedAmount.value = 0;
    thankYouReceivedCount.value = 0;

    outsideReferralCount.value = 0;
    insideReferralCount.value = 0;
    p2pMeetingCount.value = 0;

    for (final stat in stats) {
      (stat['displayValue'] as RxString).value = '0';
    }
  }
}
