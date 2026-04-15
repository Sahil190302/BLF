import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'outside_referral_controller.dart';

class OutsideReferralView extends StatelessWidget {
  final OutsideReferralController controller = Get.put(
    OutsideReferralController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Referral", showBackButton: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            _buildHeader(context),

            const SizedBox(height: 25),

            /// REFERRAL TYPE (Inside / Outside)
            _buildLabel("Referral Type"),
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildReferralTypeButton(
                      label: "Inside Referral",
                      isSelected: controller.referralType.value == "Inside",
                      onTap: () => controller.referralType.value = "Inside",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildReferralTypeButton(
                      label: "Outside Referral",
                      isSelected: controller.referralType.value == "Outside",
                      onTap: () => controller.referralType.value = "Outside",
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// REFERRAL STATUS
            _buildLabel("Referral Status"),
            Obx(
              () => Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: controller.statusList.map((status) {
                  bool selected = controller.selectedStatus.value == status;

                  return _buildOptionButton(
                    label: status,
                    isSelected: selected,
                    onTap: () => controller.selectedStatus.value = status,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// PHONE
            _buildLabel("Telephone"),
            CustomTextField(
              hint: "Enter Telephone Number",
              controller: controller.phone,
              icon: Icons.call,
            ),
            const SizedBox(height: 20),

            /// EMAIL
            _buildLabel("Email"),
            CustomTextField(
              hint: "Enter Email",
              controller: controller.email,
              icon: Icons.email,
            ),
            const SizedBox(height: 20),

            /// ADDRESS
            _buildLabel("Address"),
            CustomTextField(
              hint: "Enter Address",
              controller: controller.address,
              maxLines: 1,
              icon: Icons.location_on,
            ),
            const SizedBox(height: 20),

            /// COMMENTS
            _buildLabel("Comments"),
            _buildTextField(
              hint: "Enter Comments",
              maxLines: 3,
              onChanged: (v) => controller.comment.value = v,
            ),

            const SizedBox(height: 25),

            /// HOT REFERRAL SLIDER
            _buildLabel("How hot is this referral?"),
            Obx(
              () => Slider(
                value: controller.hotLevel.value,
                min: 1,
                max: 10,
                activeColor: AppColors.primaryDark,
                divisions: 9,
                label: controller.hotLevel.value.toString(),
                onChanged: (v) => controller.hotLevel.value = v,
              ),
            ),

            const SizedBox(height: 30),

            /// CONFIRM BUTTON
            CustomButton(
              text: "Confirm",
              onTap: controller.submitOutsideReferral,
            ),
          ],
        ),
      ),
    );
  }

  // ========================== HEADER =============================
  Widget _buildHeader(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await controller.fetchUsers();
        _openPeopleBottomSheet(context);
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
              Row(
                children: [
                  Text(
                    "Referral Person:",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.search),
                ],
              ),

              const SizedBox(height: 4),
              Text(
                controller.selectedPersons.isEmpty
                    ? "Select Person"
                    : controller.selectedPersons.join(", "),
                style: GoogleFonts.kumbhSans(
                  fontSize: 15,
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

  // ======================= LABEL =======================
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

  // ======================= TEXT FIELD =======================
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

  // ======================= OPTION BUTTON =======================
  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: GestureDetector(
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
      ),
    );
  }

  void _openPeopleBottomSheet(BuildContext context) {
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

                    final isSelected = tempSelected.contains(name);
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

            /// DONE BUTTON (FIXED + SAFE)
            Obx(
              () => SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isProcessing.value
                      ? null
                      : () {
                          isProcessing.value = true;

                          controller.selectedPersons.assignAll(tempSelected);

                          Get.back(); // instant close, no microtask
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

Widget _buildReferralTypeButton({
  required String label,
  required bool isSelected,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? AppColors.primaryDark : Colors.grey.shade400,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.kumbhSans(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.black,
          ),
        ),
      ),
    ),
  );
}
