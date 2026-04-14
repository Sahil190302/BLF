import 'package:blf/app/modules/Referral/referral_detail_screen.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'referral_controller.dart';

class ReferralScreen extends StatefulWidget {
  const ReferralScreen({super.key});

  @override
  State<ReferralScreen> createState() => _ReferralScreenState();
}

class _ReferralScreenState extends State<ReferralScreen> {

  final ReferralController controller = Get.put(ReferralController());

  @override
  void initState() {
    super.initState();
    controller.loadReferrals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: CustomAppBar(
        title: "Referral",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // merge both lists
        final combined = [
          ...controller.givenReferrals.map((e) {
            e["type"] = "Given";
            return e;
          }),
          ...controller.receivedReferrals.map((e) {
            e["type"] = "Received";
            return e;
          }),
        ];

        if (combined.isEmpty) {
          return const Center(child: Text("No referrals found"));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: combined.length,
          itemBuilder: (context, index) {
            final item = combined[index];

            return GestureDetector(
              onTap: () async {
                final result = await Get.to(
                  () => ReferralDetailScreen(data: item),
                );

                if (result == true) {
                  controller.loadReferrals();
                }
              },
              child: _buildCard(item),
            );
          },
        );
      }),
    );
  }

  Widget _buildCard(Map<String, dynamic> item) {
    final isGiven = item["type"] == "Given";

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// NAME
                Text(
                  item["referral_user_name"] ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 6),

                /// GIVEN / RECEIVED TAG
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isGiven
                        ? Colors.green.withOpacity(0.1)
                        : Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isGiven ? "Given" : "Received",
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: isGiven ? Colors.green : Colors.blue,
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                /// STATUS
                Text(
                  item["referral_status"] ?? "",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item["date"] ?? "",
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ],
      ),
    );
  }
}