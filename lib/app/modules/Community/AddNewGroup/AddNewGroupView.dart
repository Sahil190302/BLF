import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import 'AddNewGroupController.dart';

class AddNewGroupView extends StatelessWidget {
  final AddNewGroupController controller = Get.put(AddNewGroupController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: "Create Group",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _header(),

            const SizedBox(height: 18),

            _titleField(),

            const SizedBox(height: 14),

            _dropDown(
              label: "Group Type",
              items: controller.groupTypeList,
              selected: controller.groupType,
            ),

            const SizedBox(height: 14),

            _dropDown(
              label: "Access Type",
              items: controller.accessTypeList,
              selected: controller.accessType,
            ),

            const SizedBox(height: 14),

            _dropDown(
              label: "Language",
              items: controller.languageList,
              selected: controller.language,
            ),

            const SizedBox(height: 14),

            _inviteConnections(),

            const SizedBox(height: 14),

            _descriptionField(),

            const SizedBox(height: 20),

            _actionButtons(),

            const SizedBox(height: 18),

            _noteText(),
          ],
        ),
      ),
    );
  }

  // ------------------------- HEADER -------------------------
  Widget _header() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.group_add, size: 40, color: AppColors.primary),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Create a group to discuss and collaborate with other BLF Members",
                style: GoogleFonts.kumbhSans(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                "Remaining groups you may create: 7",
                style: GoogleFonts.kumbhSans(
                    fontSize: 13, color: Colors.red),
              ),
            ],
          ),
        )
      ],
    );
  }

  // ------------------------- TEXT FIELD -------------------------
  Widget _titleField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Group Name *"),
        const SizedBox(height: 6),
        _inputBox(
          child: TextField(
            style: GoogleFonts.kumbhSans(color: AppColors.black, fontSize: 14),
            onChanged: (v) => controller.groupName.value = v,
            decoration: _inputDecoration("Enter Group Name"),
          ),
        ),
      ],
    );
  }

  // ------------------------- DROPDOWN -------------------------
  Widget _dropDown({
    required String label,
    required List<String> items,
    required RxString selected,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("$label *"),
        const SizedBox(height: 6),
        Obx(() => _inputBox(
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: selected.value.isEmpty ? null : selected.value,
              hint: Text("Select",
                  style: GoogleFonts.kumbhSans(
                      fontSize: 14, color: Colors.grey)),
              items: items.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e,
                      style: GoogleFonts.kumbhSans(fontSize: 14)),
                );
              }).toList(),
              onChanged: (val) => selected.value = val!,
            ),
          ),
        )),
      ],
    );
  }

  // ------------------------- INVITE CONNECTIONS -------------------------
  Widget _inviteConnections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Invite Connections"),
        const SizedBox(height: 6),
        Obx(() => _inputBox(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${controller.selectedConnections.value} Selected",
                style: GoogleFonts.kumbhSans(
                    fontSize: 14, color: Colors.grey.shade700),
              ),
              Icon(Icons.keyboard_arrow_right,
                  color: Colors.grey.shade700),
            ],
          ),
        )),
      ],
    );
  }

  // ------------------------- DESCRIPTION -------------------------
  Widget _descriptionField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label("Group Description *"),
        const SizedBox(height: 6),
        _inputBox(
          height: 120,
          child: TextField(
            maxLines: 5,
            style: GoogleFonts.kumbhSans(color: AppColors.black, fontSize: 14),
            onChanged: (v) => controller.description.value = v,
            decoration: _inputDecoration("Enter Group Description"),
          ),
        ),
      ],
    );
  }

  // ------------------------- BUTTONS -------------------------
  Widget _actionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: controller.resetFields,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              "Reset",
              style: GoogleFonts.kumbhSans(
                  color: Colors.black, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: controller.submitForm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(
              "Submit",
              style: GoogleFonts.kumbhSans(
                  color: Colors.white, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // ------------------------- NOTE TEXT -------------------------
  Widget _noteText() {
    return Text(
      "Note: Once you have invited members to the group, please remember to come back and choose a moderator to assist with managing the discussion!",
      style: GoogleFonts.kumbhSans(
          color: Colors.red.shade700,
          fontSize: 12,
          fontWeight: FontWeight.w600),
    );
  }

  // ============================================================
  // SMALL HELPERS
  // ============================================================

  Widget _label(String text) {
    return Text(
      text,
      style:
      GoogleFonts.kumbhSans(fontSize: 14, fontWeight: FontWeight.w700),
    );
  }

  Widget _inputBox({required Widget child, double height = 50}) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: InputBorder.none,
      hintStyle: GoogleFonts.kumbhSans(color: Colors.grey, fontSize: 14),
    );
  }
}
