import 'package:blf/app/modules/Event_view/event_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class EventsView extends StatelessWidget {
  EventsView({super.key});

  final EventsController controller = Get.put(EventsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Events", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildLabel("Event Notification Type"),
            Obx(
              () => Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade400),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: controller.notificationType.value,
                    isExpanded: true,
                    items: controller.notificationTypes
                        .map(
                          (type) => DropdownMenuItem(
                            value: type,
                            child: Text(
                              type,
                              style: GoogleFonts.kumbhSans(fontSize: 16),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      controller.notificationType.value = value ?? "yearly";
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildLabel("Event Title"),
            _buildTextField(
              hint: "Enter Event Title",
              maxLines: 2,
              onChanged: (v) => controller.notificationTitle.value = v,
            ),

            const SizedBox(height: 20),

            _buildLabel("Event Detail"),
            _buildTextField(
              hint: "Enter Event Detail",
              maxLines: 4,
              onChanged: (v) => controller.notificationDetail.value = v,
            ),

            const SizedBox(height: 20),

            _buildLabel("Event Push Date"),
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );

                if (pickedDate != null) {
                  controller.notificationPushDate.text = pickedDate
                      .toIso8601String()
                      .split('T')
                      .first;
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hint: "Select date",
                  controller: controller.notificationPushDate,
                ),
              ),
            ),

            const SizedBox(height: 30),

            Obx(
              () => CustomButton(
                text: controller.isLoading.value
                    ? "Submitting..."
                    : "Submit Event",
                onTap: () {
                  if (controller.isLoading.value) return;

                  controller.submitEvent().then((success) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          success
                              ? "Event submitted successfully"
                              : "Failed to submit event",
                        ),
                      ),
                    );
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String hint,
    int maxLines = 1,
    required Function(String) onChanged,
  }) {
    return TextField(
      maxLines: maxLines,
      style: GoogleFonts.kumbhSans(fontSize: 16),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.kumbhSans(color: Colors.grey[400]),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primaryColor, width: 1.8),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
