import 'package:blf/app/modules/more/update_bio_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:blf/widgets/custom_textfield.dart';

class UpdateContactPage extends StatefulWidget {
  const UpdateContactPage({super.key});

  @override
  State<UpdateContactPage> createState() => _UpdateContactPageState();
}

class _UpdateContactPageState extends State<UpdateContactPage> {
  final phoneController = TextEditingController();
  final emailController = TextEditingController();

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

      phoneController.text = user["mobile"] ?? "";
      emailController.text = user["email"] ?? "";

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
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Update Contact", showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Phone Number"),
                  CustomTextField(
                    hint: "Enter phone number",
                    icon: Icons.phone,
                    controller: phoneController,
                    keyboard: TextInputType.phone,
                  ),

                  const SizedBox(height: 14),

                  _label("Email Address"),
                  CustomTextField(
                    hint: "Enter email address",
                    icon: Icons.email,
                    controller: emailController,
                    keyboard: TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 30),

                  CustomButton(
                    text: "Update",
                    onTap: () async {
                      if (userData == null || userSno == null) return;

                      final payload = {
                        "name": userData!["name"],
                        "dob": userData!["dob"],
                        "email": emailController.text,
                        "password": userData!["password"],
                        "mobile": phoneController.text,
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
                          const SnackBar(content: Text("Contact Updated")),
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
}
