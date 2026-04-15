import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'controller/one_to_one_meeting_controller.dart';
import 'package:intl/intl.dart';

class OneToOneMeetingView extends StatelessWidget {
  OneToOneMeetingView({super.key});

  final OneToOneMeetingController controller = Get.put(
    OneToOneMeetingController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "One-to-One Meeting", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// MET WITH
            _buildMetWithHeader(context),
            const SizedBox(height: 20),

            /// INITIATED BY
            _buildLabel("Initiated By"),
            Obx(
              () => Row(
                children: controller.initiatedByList.map((option) {
                  bool selected =
                      controller.selectedInitiatedBy.value == option;
                  return _buildOptionButton(
                    label: option,
                    isSelected: selected,
                    onTap: () => controller.selectedInitiatedBy.value = option,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// LOCATION
            _buildLabel("Meeting Location"),
            CustomTextField(
              hint: "Enter location",
              controller: controller.locationController,
              icon: Icons.location_on,
            ),

            const SizedBox(height: 20),

            /// DATE
            _buildLabel("Meeting Date"),
            Obx(
              () => GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: controller.meetingDate.value,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) controller.meetingDate.value = picked;
                },
                child: _buildDateBox(),
              ),
            ),

            const SizedBox(height: 20),

            /// AGENDA
            _buildLabel("Agenda"),
            _buildTextField(
              hint: "Enter meeting agenda",
              maxLines: 3,
              onChanged: (v) => controller.agenda.value = v,
            ),

            const SizedBox(height: 20),

            /// SUMMARY
            _buildLabel("Meeting Summary"),
            _buildTextField(
              hint: "Enter meeting summary",
              maxLines: 3,
              onChanged: (v) => controller.summary.value = v,
            ),

            const SizedBox(height: 20),

            /// FOLLOW-UP REMINDER
            // Obx(
            //   () => SwitchListTile(
            //     contentPadding: EdgeInsets.zero,
            //     title: Text(
            //       "Set Follow-up Reminder",
            //       style: GoogleFonts.kumbhSans(fontWeight: FontWeight.w600),
            //     ),
            //     value: controller.followUpReminder.value,
            //     activeColor: AppColors.primaryDark,
            //     onChanged: (v) => controller.followUpReminder.value = v,
            //   ),
            // ),
            const SizedBox(height: 20),

            _buildLabel("Meeting Image"),

            Obx(() {
              return GestureDetector(
                onTap: controller.pickImage,
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.primaryDark),
                  ),
                  child: controller.meetingImage.value == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.upload_file, size: 40),
                            SizedBox(height: 6),
                            Text("Upload Image"),
                          ],
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Image.file(
                            controller.meetingImage.value!,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              );
            }),

            const SizedBox(height: 30),

            /// SUBMIT
            CustomButton(text: "Submit", onTap: controller.submitMeeting),
          ],
        ),
      ),
    );
  }

  // ================= UI HELPERS =================

  Widget _buildDateBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkgreen, width: 1.5),
      ),
      child: Text(
        DateFormat('EEEE, dd MMM yyyy').format(controller.meetingDate.value),
        style: GoogleFonts.kumbhSans(fontSize: 16),
      ),
    );
  }

  Widget _buildMetWithHeader(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.fetchUsers();
        _openMetWithBottomSheet(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Met With:",
                style: GoogleFonts.kumbhSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                controller.selectedPersons.isEmpty
                    ? "Select Person"
                    : controller.selectedPersons.join(", "),
                style: GoogleFonts.kumbhSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
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

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryDark.withOpacity(0.9)
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.green),
        ),
        child: Text(
          label,
          style: GoogleFonts.kumbhSans(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.black,
          ),
        ),
      ),
    );
  }

  void _openMetWithBottomSheet(BuildContext context) {
    final RxList<String> tempSelected = List<String>.from(
      controller.selectedPersons,
    ).obs;

    final RxList<Map<String, dynamic>> tempFiltered =
        List<Map<String, dynamic>>.from(controller.users).obs;

    final TextEditingController searchCtrl = TextEditingController();
    final RxBool isProcessing = false.obs;

    Get.bottomSheet(
      Container(
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            /// HANDLE
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 12),

            /// TITLE
            Text(
              "Select People",
              style: GoogleFonts.kumbhSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 12),

            /// SEARCH
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search person",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (val) {
                tempFiltered.assignAll(
                  controller.users.where(
                    (u) => u['name'].toString().toLowerCase().contains(
                      val.toLowerCase(),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 12),

            /// LIST
            Expanded(
              child: Obx(() {
                if (tempFiltered.isEmpty) {
                  return const Center(child: Text("No users found"));
                }

                return ListView.builder(
                  itemCount: tempFiltered.length,
                  itemBuilder: (_, index) {
                    final user = tempFiltered[index];
                    final name = user['name'].toString();

                    return Obx(() {
                      final isSelected = tempSelected.contains(name);

                      return InkWell(
                        onTap: () {
                          if (isSelected) {
                            tempSelected.remove(name);
                          } else {
                            tempSelected.add(name);
                          }
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.12)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 150),
                                child: Icon(
                                  isSelected
                                      ? Icons.check_box
                                      : Icons.check_box_outline_blank,
                                  key: ValueKey(isSelected),
                                  color: AppColors.primaryDark,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                );
              }),
            ),

            const SizedBox(height: 10),

            /// DONE BUTTON
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isProcessing.value
                      ? null
                      : () {
                          isProcessing.value = true;
                          controller.selectedPersons.assignAll(tempSelected);
                          Get.back(); // immediate close
                        },
                  child: isProcessing.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Done"),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}
