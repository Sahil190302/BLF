// lib/app/modules/slips/slips_controller.dart

import 'package:get/get.dart';

class SlipsController extends GetxController {
  final RxInt selectedTab = 0.obs;
  final RxList<Slip> givenSlips = <Slip>[].obs;
  final RxList<Slip> receivedSlips = <Slip>[].obs;
  var query = ''.obs;

  var isFabOpen = false.obs;

  void toggleFab() {
    isFabOpen.value = !isFabOpen.value;
  }

  @override
  void onInit() {
    super.onInit();
    _initializeDummyData();
  }

  /// 🔍 Your search function (you can add filter logic later)
  searchFilteredList() {
    // Example return:
    // return currentList.where((e) => e.name.toLowerCase().contains(query.value.toLowerCase())).toList();
  }

  /// 📌 INITIAL DUMMY DATA (Given + Received)
  void _initializeDummyData() {
    /// GIVEN SLIPS LIST
    givenSlips.assignAll([
      Slip(
        id: '1',
        name: 'John Smith',
        date: DateTime(2024, 1, 15),
        amount: 250.00,
        type: SlipType.given,
        status: SlipStatus.completed,
        description: 'Website Development Project',
        category: 'SLIPS',
      ),
      Slip(
        id: '2',
        name: 'Sarah Johnson',
        date: DateTime(2024, 1, 12),
        amount: 150.00,
        type: SlipType.given,
        status: SlipStatus.pending,
        description: 'Marketing Consultation',
        category: 'Legal Services',
      ),
      Slip(
        id: '3',
        name: 'Amit Sharma',
        date: DateTime(2024, 1, 10),
        amount: 180.00,
        type: SlipType.given,
        status: SlipStatus.pending,
        description: 'Invoice Preparation',
        category: 'Accounting Services',
      ),
      Slip(
        id: '4',
        name: 'Ravi Patel',
        date: DateTime(2024, 1, 8),
        amount: 90.00,
        type: SlipType.given,
        status: SlipStatus.pending,
        description: 'Small office task',
        category: 'SLIPS',
      ),
      // --- NEW DATA ADDED BELOW ---
      Slip(
        id: '9',
        name: 'Lisa Wong',
        date: DateTime(2024, 1, 4),
        amount: 500.00,
        type: SlipType.given,
        status: SlipStatus.completed,
        description: 'Logo Design & Branding',
        category: 'Design Services',
      ),
      Slip(
        id: '10',
        name: 'James Carter',
        date: DateTime(2023, 12, 28),
        amount: 75.00,
        type: SlipType.given,
        status: SlipStatus.cancelled,
        description: 'Consultation Fee',
        category: 'Consulting',
      ),
      Slip(
        id: '11',
        name: 'Maria Garcia',
        date: DateTime(2023, 12, 20),
        amount: 1200.00,
        type: SlipType.given,
        status: SlipStatus.completed,
        description: 'Full Website Overhaul',
        category: 'SLIPS',
      ),
    ]);

    /// RECEIVED SLIPS LIST
    receivedSlips.assignAll([
      Slip(
        id: '5',
        name: 'Mike Wilson',
        date: DateTime(2024, 1, 10),
        amount: 300.00,
        type: SlipType.received,
        status: SlipStatus.completed,
        description: 'Legal Services',
        category: 'Legal Services',
      ),
      Slip(
        id: '6',
        name: 'Emily Davis',
        date: DateTime(2024, 1, 8),
        amount: 175.50,
        type: SlipType.received,
        status: SlipStatus.completed,
        description: 'Accounting Services',
        category: 'Accounting Services',
      ),
      Slip(
        id: '7',
        name: 'David Brown',
        date: DateTime(2024, 1, 5),
        amount: 220.75,
        type: SlipType.received,
        status: SlipStatus.pending,
        description: 'Slip Entry',
        category: 'SLIPS',
      ),
      Slip(
        id: '8',
        name: 'David Brown', // Duplicate name intentional based on previous data
        date: DateTime(2024, 1, 5),
        amount: 220.75,
        type: SlipType.received,
        status: SlipStatus.pending,
        description: 'Slip Entry',
        category: 'SLIPS',
      ),
      // --- NEW DATA ADDED BELOW ---
      Slip(
        id: '12',
        name: 'Robert Taylor',
        date: DateTime(2024, 1, 3),
        amount: 450.00,
        type: SlipType.received,
        status: SlipStatus.completed,
        description: 'Annual Tax Filing',
        category: 'Accounting Services',
      ),
      Slip(
        id: '13',
        name: 'Sophie Martin',
        date: DateTime(2023, 12, 29),
        amount: 85.00,
        type: SlipType.received,
        status: SlipStatus.cancelled,
        description: 'Coffee Meeting Expense',
        category: 'SLIPS',
      ),
      Slip(
        id: '14',
        name: 'Tech Solutions Inc.',
        date: DateTime(2023, 12, 25),
        amount: 2000.00,
        type: SlipType.received,
        status: SlipStatus.completed,
        description: 'Server Maintenance Contract',
        category: 'IT Services',
      ),
    ]);
  }

  /// 🔄 Change tab (0 = Given, 1 = Received)
  void changeTab(int index) {
    selectedTab.value = index;
  }

  /// Get current visible list automatically
  List<Slip> get currentList {
    return selectedTab.value == 0 ? givenSlips : receivedSlips;
  }
}
// lib/app/modules/slips/models/slip_model.dart

class Slip {
  final String id;
  final String name;
  final DateTime date;
  final double amount;
  final SlipType type;
  final SlipStatus status;
  final String? description;
  final String? category;

  Slip({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.type,
    required this.status,
    this.description,
    this.category,
  });

  /// ------------------------------
  /// JSON FACTORY
  /// ------------------------------
  factory Slip.fromJson(Map<String, dynamic> json) {
    return Slip(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      date: DateTime.parse(json['date']),
      amount: (json['amount'] ?? 0).toDouble(),
      type: SlipType.values[json['type'] ?? 0],
      status: SlipStatus.values[json['status'] ?? 0],
      description: json['description'],
      category: json['category'],
    );
  }

  /// ------------------------------
  /// JSON MAP
  /// ------------------------------
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'date': date.toIso8601String(),
      'amount': amount,
      'type': type.index,
      'status': status.index,
      'description': description,
      'category': category,
    };
  }

  /// ------------------------------
  /// FORMATTERS
  /// ------------------------------
  String get formattedAmount => '\$${amount.toStringAsFixed(2)}';

  String get formattedDate {
    return '${_month(date.month)} ${date.day}, ${date.year}';
  }

  /// Month abbreviation
  String _month(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

/// ------------------------------
/// ENUMS
/// ------------------------------

enum SlipType { given, received }

enum SlipStatus { pending, completed, cancelled }
