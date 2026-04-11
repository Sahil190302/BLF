import 'package:blf/app/modules/Notification_Quick_Action/notification_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:blf/widgets/custom_appbar.dart';

class NotificationDetailScreen extends StatefulWidget {
  final Map<String, dynamic> data;

  const NotificationDetailScreen({super.key, required this.data});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {

  @override
  void initState() {
    super.initState();
    _markNotificationRead();
  }

  Future<void> _markNotificationRead() async {
    try {

      final user = await HomeApi.fetchUser();
      final userId = user["sno"];

      final notificationId = widget.data["sno"];

      await NotificationApi.processNotification(
        userId: userId,
        notificationId: notificationId,
      );

    } catch (e) {
      print("Notification read error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {

    final type = widget.data["notification_type"] ?? "";
    final title = widget.data["notification_title"] ?? "";
    final detail = widget.data["notification_detail"] ?? "";
    final pushDate = widget.data["notification_push_date"] ?? "";

    Color typeColor;

    switch (type.toLowerCase()) {
      case "once":
        typeColor = Colors.blue;
        break;
      case "yearly":
        typeColor = Colors.green;
        break;
      default:
        typeColor = Colors.grey;
    }

    return Scaffold(
      backgroundColor: const Color(0xfff4f6fa),
      appBar: const CustomAppBar(title: "Event Detail", showBackButton: true),

      body: Column(
        children: [

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 4),

              child: Container(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 12),

                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xffffffff), Color(0xfff8f9fc)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: Color(0xff1a1a1a),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Row(
                      children: [
                        _badge(type, typeColor),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today,
                              size: 16,
                              color: Colors.grey,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              pushDate,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),
                    Divider(color: Colors.grey.shade300),
                    const SizedBox(height: 18),

                    Text(
                      "Details",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(children: _buildDetailItems(detail)),
                    ),
                  ],
                ),
              ),
            ),
          ),

         
        ],
      ),
    );
  }



  List<Widget> _buildDetailItems(String detail) {

    final parts = detail.split("|");

    return parts.map((part) {

      final cleaned = part.trim();
      final splitIndex = cleaned.indexOf("-");

      String label = "";
      String value = cleaned;

      if (splitIndex != -1) {
        label = cleaned.substring(0, splitIndex).trim();
        value = cleaned.substring(splitIndex + 1).trim();
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 14),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const Icon(Icons.circle, size: 8, color: Colors.blue),
            const SizedBox(width: 10),

            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xff2d2d2d),
                  ),
                  children: [

                    if (label.isNotEmpty)
                      TextSpan(
                        text: "$label: ",
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xff1a1a1a),
                        ),
                      ),

                    TextSpan(
                      text: value,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );

    }).toList();
  }

  Widget _badge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}