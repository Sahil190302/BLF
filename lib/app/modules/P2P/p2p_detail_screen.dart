import 'package:blf/app/modules/P2P/p2p_api.dart';
import 'package:blf/app/modules/Referral/referral_api.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class P2PDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const P2PDetailScreen({super.key, required this.data});

  @override
  State<P2PDetailScreen> createState() => _P2PDetailScreenState();
}

class _P2PDetailScreenState extends State<P2PDetailScreen> {
  String userName = "";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final sno = widget.data["with_user_id"].toString();

      final name = await ReferralApi.fetchUserNameBySno(sno);

      setState(() {
        userName = name;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        userName = "Unknown";
        isLoading = false;
      });
    }
  }
Widget _buildMeetingImage(String path) {

  final cleaned = path.replaceFirst(RegExp(r'^\.\./img/'), '');
  final imageUrl =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/$cleaned";

  debugPrint("RAW IMAGE PATH → $path");
  debugPrint("CLEANED PATH → $cleaned");
  debugPrint("FINAL IMAGE URL → $imageUrl");

  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "Meeting Image",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 0.5,
          ),
        ),

        const SizedBox(height: 10),

        GestureDetector(
          onTap: () {
            debugPrint("OPEN FULL IMAGE → $imageUrl");

            showDialog(
              context: context,
              builder: (_) => Dialog(
                backgroundColor: Colors.black,
                insetPadding: const EdgeInsets.all(10),
                child: InteractiveViewer(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            );
          },

          child: Container(
            height: 120,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade200,
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),

            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Colors.black.withOpacity(0.35),
              ),
              child: const Text(
                "View Image",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        const Divider(height: 20, thickness: 0.5),
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff4f6f9),
      appBar: CustomAppBar(title: "P2P Meeting Details", showBackButton: true),
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
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
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
                          _buildHeader(),
                          const SizedBox(height: 20),
                          if (widget.data["image"] != null &&
                              widget.data["image"].toString().isNotEmpty)
                            _buildMeetingImage(widget.data["image"]),

                          _buildField("Meeting With", userName),
                          _buildField(
                            "Initiated By",
                            widget.data["initiated_by"],
                          ),
                          _buildField("Location", widget.data["location"]),
                          _buildField(
                            "Meeting Date",
                            widget.data["meeting_date"],
                          ),
                          _buildField("Created Date", widget.data["date"]),
                          _buildField("Agenda", widget.data["agenda"]),
                          _buildField(
                            "Meeting Summary",
                            widget.data["meeting_summary"],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                /// DELETE SECTION
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
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: _deleteMeeting,
                      icon: const Icon(Icons.delete_outline),
                      label: const Text(
                        "Delete Meeting",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Future<void> _deleteMeeting() async {
    final int? sno = widget.data["sno"];
    if (sno == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: const Text("Delete Meeting"),
        content: const Text(
          "This action cannot be undone.\nDo you want to continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
            ),
            child: const Text("Delete"),
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

      await P2PApi.deleteMeeting(sno);

      if (!mounted) return;

      Navigator.pop(context); // remove loader
      Navigator.pop(context, true); // go back
    } catch (e) {
      if (!mounted) return;

      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade600,
          content: Text(e.toString()),
        ),
      );
    }
  }

  Widget _buildHeader() {
    return Row(
      children: const [
        Icon(Icons.assignment, color: Colors.green, size: 28),
        SizedBox(width: 10),
        Text(
          "Meeting Information",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildField(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value?.toString() ?? "-",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const Divider(height: 20, thickness: 0.5),
        ],
      ),
    );
  }
}
