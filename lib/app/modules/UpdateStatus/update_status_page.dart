import 'package:blf/widgets/custom_button.dart';
import 'package:blf/widgets/custom_textfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../ReferralSlip/referral_slip_view.dart';
import 'UpdateStatusController.dart';

class UpdateStatusPage extends StatelessWidget {
  UpdateStatusPage({super.key});

  final UpdateStatusController controller = Get.put(UpdateStatusController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Update Status", showBackButton: true),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDate(controller),
                const SizedBox(height: 20),
                _buildName(controller),
                const SizedBox(height: 20),
                _buildStatus(controller),
                const SizedBox(height: 20),
                _buildComments(controller),
                const SizedBox(height: 30),
                CustomButton(text: "UPDATE", onTap: () => controller.updateStatus()),
              ],
            );
          }),
        ),
      ),
    );
  }

  // -------------------- DATE BOX --------------------
  Widget _buildDate(UpdateStatusController c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkgreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: () async {
          final pick = await showDatePicker(
            context: Get.context!,
            initialDate: c.selectedDate.value,
            firstDate: DateTime(2024, 12, 1),
            lastDate: DateTime(2024, 12, 31),
          );
          if (pick != null) c.selectedDate.value = pick;
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.offline_share,
              color: Colors.white,
            ),
            const SizedBox(width: 10),

            // MAIN TEXT SECTION
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      // DATE TEXT
                      Expanded(
                        child: Text(
                          "Date: ${c.selectedDate.value.day}-"
                              "${c.selectedDate.value.month}-"
                              "${c.selectedDate.value.year}",
                          style: GoogleFonts.kumbhSans(
                            color: AppColors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      // ICON RIGHT SIDE
                      GestureDetector(
                        onTap: (){
                          Get.to(ReferralSlipPage());
                        },
                        child: Icon(
                          CupertinoIcons.eye_fill,
                          color: AppColors.white,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  // NAME
                  Text(
                    "Abhi Josi",
                    style: GoogleFonts.kumbhSans(
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------- NAME FIELD --------------------
  Widget _buildName(UpdateStatusController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        CustomTextField(
          hint: "Enter Name",
          icon: Icons.person,
          controller: controller.nametextfiled,
        ),

              ],
    );
  }

  // -------------------- STATUS DROPDOWN --------------------
  Widget _buildStatus(UpdateStatusController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Status",
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),

        const SizedBox(height: 6),

        // ----------------- LIST STYLE LIKE SCREENSHOT -----------------
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: c.statusList.length,
          itemBuilder: (context, index) {
            String status = c.statusList[index];
            bool isSelected = c.selectedStatus.value == status;

            return GestureDetector(
              onTap: () => c.selectedStatus.value = status,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: const BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey, width: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        status,
                        style: GoogleFonts.kumbhSans(
                          fontSize: 16,
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    // RIGHT COLOR BAR
                    Container(
                      width: 40,
                      height: 35,
                      decoration: BoxDecoration(
                        color: _getStatusColor(status),
                      ),
                      child: isSelected
                          ? const Icon(Icons.check, color: Colors.white)
                          : null,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // -------------------- COMMENTS --------------------
  Widget _buildComments(UpdateStatusController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Comments",
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            color: AppColors.textLight,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),

        TextFormField(
          controller:c.commentstextfiled,   // ← Use GetX controller directly
          maxLines: 4,
          style: GoogleFonts.kumbhSans(
            fontSize: 16,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: AppColors.primaryColor, width: 1.8),
            ),
            contentPadding: const EdgeInsets.all(12),
            hintText: "Add comments",
            hintStyle: GoogleFonts.kumbhSans(
              color: Colors.grey.shade500,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  // Helper method to get color for status tags
  final Map<String, Color> _assignedColors = {};
  final List<Color> _uniqueColors = [
    Colors.grey,
    Colors.yellow,
    Colors.blue,
    Colors.green,
    Colors.red,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.brown,
    Colors.black,
  ];

  Color _getStatusColor(String status) {
    if (_assignedColors.containsKey(status)) {
      return _assignedColors[status]!;
    }

    // Assign next unused color
    if (_assignedColors.length < _uniqueColors.length) {
      _assignedColors[status] = _uniqueColors[_assignedColors.length];
    } else {
      // Fallback (in case statuses exceed colors)
      _assignedColors[status] = Colors.grey;
    }

    return _assignedColors[status]!;
  }
}