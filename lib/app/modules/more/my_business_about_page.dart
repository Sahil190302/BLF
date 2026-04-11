import 'package:blf/app/modules/more/update_bio_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';

class MyBusinessAboutPage extends StatefulWidget {
  const MyBusinessAboutPage({super.key});

  @override
  State<MyBusinessAboutPage> createState() => _MyBusinessAboutPageState();
}

class _MyBusinessAboutPageState extends State<MyBusinessAboutPage> {
  final aboutController = TextEditingController();

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

      aboutController.text = user["business_address"] ?? "";

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
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "My Business", showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "About Business",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: aboutController,
                    maxLines: 6,
                    style: GoogleFonts.kumbhSans(fontSize: 14),
                    decoration: InputDecoration(
                      hintText: "Enter about your business...",
                      hintStyle: GoogleFonts.kumbhSans(
                        color: AppColors.textLight,
                      ),
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.red),
                      ),
                    ),
                  ),

                  const Spacer(),

                  CustomButton(
                    text: "Update",
                    onTap: () async {
                      if (userData == null || userSno == null) return;

                      final payload = {
                        "name": userData!["name"],
                        "dob": userData!["dob"],
                        "email": userData!["email"],
                        "password": userData!["password"],
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
                        "business_address": aboutController.text,
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
                          const SnackBar(
                            content: Text("Business Info Updated"),
                          ),
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
}
