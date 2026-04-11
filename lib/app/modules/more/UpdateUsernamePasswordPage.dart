import 'package:blf/app/modules/more/update_bio_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:blf/widgets/custom_textfield.dart';

class UpdateUsernamePasswordPage extends StatefulWidget {
  const UpdateUsernamePasswordPage({super.key});

  @override
  State<UpdateUsernamePasswordPage> createState() =>
      _UpdateUsernamePasswordPageState();
}

class _UpdateUsernamePasswordPageState
    extends State<UpdateUsernamePasswordPage> {
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  Map<String, dynamic>? userData;
  int? userSno;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final user = await HomeApi.fetchUser();

      userData = user;
      userSno = user["sno"];

      usernameController.text = user["name"] ?? "";

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Update Username & Password",
        showBackButton: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Username"),
                  CustomTextField(
                    hint: "Enter username",
                    controller: usernameController,
                    icon: Icons.person,
                  ),

                  _gap(),

                  _label("Current Password"),
                  CustomTextField(
                    hint: "Enter current password",
                    controller: currentPasswordController,
                    icon: Icons.lock_outline,
                    obscure: true,
                  ),

                  _gap(),

                  _label("New Password"),
                  CustomTextField(
                    hint: "Enter new password",
                    controller: newPasswordController,
                    icon: Icons.lock,
                    obscure: true,
                  ),

                  _gap(),

                  _label("Confirm New Password"),
                  CustomTextField(
                    hint: "Re-enter new password",
                    controller: confirmPasswordController,
                    icon: Icons.lock,
                    obscure: true,
                  ),

                  const SizedBox(height: 30),

                  CustomButton(
                    text: "Update Credentials",
                    onTap: () async {
                      if (newPasswordController.text !=
                          confirmPasswordController.text) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Passwords do not match"),
                          ),
                        );
                        return;
                      }

                      if (userData == null || userSno == null) return;

                      final payload = {
                        "name": usernameController.text,
                        "dob": userData!["dob"],
                        "email": userData!["email"],
                        "password": newPasswordController.text,
                        "mobile": userData!["mobile"],
                        "address1": userData!["address1"],
                        "address2": userData!["address2"],
                        "city": userData!["city"],
                        "state": userData!["state"],
                        "pincode": userData!["pincode"],
                        "profile_image": userData!["profile_image"],
                        "business_name": userData!["business_name"],
                        "business_category": userData!["business_category"],
                        "business_registration_no":
                            userData!["business_registration_no"],
                        "business_address": userData!["business_address"],
                        "business_website": userData!["business_website"],
                        "social_media_link": userData!["social_media_link"],
                        "business_year": userData!["business_year"],
                        "previous_job": userData!["previous_job"],
                        "spouse_children": userData!["spouse_children"],
                        "pets": userData!["pets"],
                        "hobbies": userData!["hobbies"],
                        "city_residence": userData!["city_residence"],
                        "city_year": userData!["city_year"],
                        "business_desire": userData!["business_desire"],
                        "something_aboutme": userData!["something_aboutme"],
                        "keyto_success": userData!["keyto_success"],
                        "date": userData!["date"],
                        "group_create_limit": userData!["group_create_limit"],
                        "status": userData!["status"],
                      };

                      final success = await UpdateBioApi.updateUserBio(
                        sno: userSno!,
                        data: payload,
                      );

                      if (success) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Credentials Updated")),
                        );
                        Future.microtask(() {
                          Navigator.of(context).pop(true);
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.black,
        ),
      ),
    );
  }

  Widget _gap() => const SizedBox(height: 14);
}
