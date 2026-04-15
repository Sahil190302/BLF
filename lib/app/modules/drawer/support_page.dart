import 'dart:convert';
import 'package:blf/app/services/home_api.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String selectedIssue = "General Query";
  final TextEditingController messageController = TextEditingController();
  bool isSubmitting = false;
  final List<String> issues = [
    "General Query",
    "Technical Issue",
    "Payment Issue",
    "Account Problem",
    "Feedback",
    "Other",
  ];

  int? userId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await HomeApi.fetchUser();
      userId = user["sno"];
    } catch (e) {
      debugPrint(e.toString());
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<bool> submitSupportRequest() async {
    final today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    final response = await http.post(
      Uri.parse(
        "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/api/index.php",
      ),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "action": "insert",
        "table": "support",
        "data": {
          "user_id": userId.toString(),
          "type": selectedIssue,
          "message": messageController.text,
          "date": today,
        },
      }),
    );

    final data = jsonDecode(response.body);

    return response.statusCode == 200 && data["status"] == true;
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Support", showBackButton: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Need Help?",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "Tell us your issue and our support team will contact you.",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 13,
                    color: AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 25),

                Text(
                  "Issue Type",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedIssue,
                      isExpanded: true,
                      items: issues
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(
                                e,
                                style: GoogleFonts.kumbhSans(fontSize: 14),
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedIssue = value!;
                        });
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  "Message",
                  style: GoogleFonts.kumbhSans(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                TextField(
                  controller: messageController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: "Describe your issue here...",
                    hintStyle: GoogleFonts.kumbhSans(
                      color: AppColors.textLight,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppColors.red),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.email, color: AppColors.red),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "You can also email us at\nsupport@yourapp.com",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text: "Submit Request",
                  onTap: () async {
                    if (messageController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Please enter your message"),
                        ),
                      );
                      return;
                    }

                    setState(() => isSubmitting = true);

                    final success = await submitSupportRequest();

                    setState(() => isSubmitting = false);

                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Support request submitted successfully",
                          ),
                        ),
                      );
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Failed to submit request"),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          if (isSubmitting)
            Container(
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
