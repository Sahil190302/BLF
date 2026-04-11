import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import 'TYFCBController.dart';

class TyfcbView extends StatelessWidget {
  TyfcbView({super.key});

  final TyfcbController controller = Get.put(TyfcbController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Acknowledgement", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// HEADER
            _buildHeader(context),

            const SizedBox(height: 25),

            /// AMOUNT
            _buildLabel("Amount Closed"),
            CustomTextField(
              hint: "Enter Amount",
              icon: Icons.currency_rupee,
              controller: controller.amount,
              keyboard: TextInputType.number,
            ),

            const SizedBox(height: 20),

            /// BUSINESS CATEGORY
            _buildLabel("Business Category"),
            Obx(
              () => Wrap(
                spacing: 12,
                runSpacing: 10,
                children: controller.businessCategories.map((type) {
                  bool selected = controller.businessCategory.value == type;
                  return _buildOptionButton(
                    label: type,
                    isSelected: selected,
                    onTap: () => controller.businessCategory.value = type,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// REFERRAL TYPE
            _buildLabel("Referral Type"),
            Obx(
              () => Wrap(
                spacing: 12,
                children: controller.referralTypes.map((type) {
                  bool selected = controller.referralType.value == type;
                  return _buildOptionButton(
                    label: type,
                    isSelected: selected,
                    onTap: () => controller.referralType.value = type,
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            /// COMMENTS
            _buildLabel("Description"),
            _buildTextField(
              hint: "Enter deal description",
              maxLines: 3,
              onChanged: (v) => controller.comment.value = v,
            ),

            const SizedBox(height: 25),

            /// INFO TEXT
            Text(
              "Note: TYFCB will be completed after receiver approval.",
              style: GoogleFonts.kumbhSans(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),

            const SizedBox(height: 20),

            /// SUBMIT BUTTON
            CustomButton(text: "Submit BAC", onTap: controller.submitTYFCB),
          ],
        ),
      ),
    );
  }

  // ===================== UI COMPONENTS ======================

  Widget _buildHeader(context) {
    return GestureDetector(
      onTap: () => _openPeopleBottomSheet(context),
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
                    "Thank You Given To:",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[600],
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.search),
                ],
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

  Widget _buildOptionButton({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryDark : Colors.white,
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

  void _openPeopleBottomSheet(BuildContext context) {
    Get.bottomSheet(
      Obx(() {
        return Container(
          height: MediaQuery.of(context).size.height * 0.85,
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
          ),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Select People",
                style: GoogleFonts.kumbhSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: controller.searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search person",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.filteredUsers.length,
                  itemBuilder: (_, index) {
                    final user = controller.filteredUsers[index];
                    final name = user['name'].toString();

                    return Obx(() {
                      final isSelected = controller.selectedPersons.contains(
                        name,
                      );

                      return GestureDetector(
                        onTap: () {
                          if (isSelected) {
                            controller.selectedPersons.remove(name);
                          } else {
                            controller.selectedPersons.add(name);
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryDark
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primaryDark
                                  : Colors.grey.shade300,
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                isSelected
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primaryDark,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  name,
                                  style: GoogleFonts.kumbhSans(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),

              CustomButton(
                text: "Done",
                onTap: () => Future.microtask(() {
                  Navigator.of(context).pop();
                }),
              ),
            ],
          ),
        );
      }),
      isScrollControlled: true,
    );
  }
}
