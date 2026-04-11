import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'referral_api.dart';

class ReferralDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const ReferralDetailScreen({super.key, required this.data});

  @override
  State<ReferralDetailScreen> createState() => _ReferralDetailScreenState();
}

class _ReferralDetailScreenState extends State<ReferralDetailScreen> {
  bool isLoading = true;

  final referralUserIdController = TextEditingController();
  final referralTypeController = TextEditingController();
  final referralStatusController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final addressController = TextEditingController();
  final commentController = TextEditingController();
  final hotRatingController = TextEditingController();
  final dateController = TextEditingController();

  @override
  void initState() {
    super.initState();

    referralUserIdController.text = widget.data["referral_user_id"].toString();

    referralTypeController.text = widget.data["referral_type"] ?? "";

    referralStatusController.text = widget.data["referral_status"] ?? "";

    emailController.text = widget.data["email"] ?? "";

    mobileController.text = widget.data["mobile"] ?? "";

    addressController.text = widget.data["address"] ?? "";

    commentController.text = widget.data["comment"] ?? "";

    hotRatingController.text = widget.data["referral_hot_rating"] ?? "";

    dateController.text = widget.data["date"] ?? "";

    isLoading = false;
  }

  Future<void> _updateReferral() async {
    final int sno = widget.data["sno"];

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await ReferralApi.updateReferral(
        sno: widget.data["sno"],
        referralUserId: int.parse(referralUserIdController.text),
        referralType: referralTypeController.text,
        referralStatus: referralStatusController.text,
        email: emailController.text,
        mobile: mobileController.text,
        address: addressController.text,
        comment: commentController.text,
        referralHotRating: hotRatingController.text,
        date: dateController.text,
      );

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Referral updated successfully")),
      );

      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _deleteReferral() async {
    final int sno = widget.data["sno"];

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this referral?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      await ReferralApi.deleteReferral(sno);

      Navigator.pop(context);
      Navigator.pop(context, true);
    } catch (e) {
      Navigator.pop(context);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> _pickDate() async {
    DateTime initial = DateTime.tryParse(dateController.text) ?? DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      dateController.text = picked.toIso8601String().split("T").first;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f9),
      appBar: CustomAppBar(title: "Referral Details", showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(18),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xffe8f5e9), Color(0xffffffff)],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildInputField(
                            "Referral User ID",
                            referralUserIdController,
                          ),

                          _buildInputField(
                            "Referral Type",
                            referralTypeController,
                          ),

                          _buildInputField(
                            "Referral Status",
                            referralStatusController,
                          ),

                          _buildInputField("Email", emailController),

                          _buildInputField("Mobile", mobileController),

                          _buildInputField("Address", addressController),

                          _buildInputField("Hot Rating", hotRatingController),

                          _buildDateField(),

                          _buildInputField("Comment", commentController),
                        ],
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _updateReferral,
                          icon: const Icon(Icons.edit),
                          label: const Text("Update Referral"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.lightGreen,
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _deleteReferral,
                          icon: const Icon(Icons.delete),
                          label: const Text("Delete Referral"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: dateController,
        readOnly: true,
        onTap: _pickDate,
        decoration: InputDecoration(
          labelText: "Date",
          suffixIcon: const Icon(Icons.calendar_today),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }
}
