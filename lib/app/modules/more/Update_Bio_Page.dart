import 'package:blf/app/modules/more/update_bio_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:blf/widgets/custom_textfield.dart';

class UpdateBioPage extends StatefulWidget {
  const UpdateBioPage({super.key});

  @override
  State<UpdateBioPage> createState() => _UpdateBioPageState();
}

class _UpdateBioPageState extends State<UpdateBioPage> {
  final businessYearsController = TextEditingController();
  final previousJobController = TextEditingController();
  final jobTypeController = TextEditingController();
  final spouseChildrenController = TextEditingController();
  final petsController = TextEditingController();
  final hobbiesController = TextEditingController();
  final cityController = TextEditingController();
  final cityYearsController = TextEditingController();
  final businessDesireController = TextEditingController();
  final secretController = TextEditingController();
  final successController = TextEditingController();
  int? userSno;
  Map<String, dynamic>? userData;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = await HomeApi.fetchUser();

      userData = user;
      userSno = user["sno"];

      businessYearsController.text = user["business_year"] ?? "";
      previousJobController.text = user["previous_job"] ?? "";
      jobTypeController.text = user["business_category"] ?? "";
      spouseChildrenController.text = user["spouse_children"] ?? "";
      petsController.text = user["pets"] ?? "";
      hobbiesController.text = user["hobbies"] ?? "";
      cityController.text = user["city_residence"] ?? "";
      cityYearsController.text = user["city_year"] ?? "";
      businessDesireController.text = user["business_desire"] ?? "";
      secretController.text = user["something_aboutme"] ?? "";
      successController.text = user["keyto_success"] ?? "";

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
    businessYearsController.dispose();
    previousJobController.dispose();
    jobTypeController.dispose();
    spouseChildrenController.dispose();
    petsController.dispose();
    hobbiesController.dispose();
    cityController.dispose();
    cityYearsController.dispose();
    businessDesireController.dispose();
    secretController.dispose();
    successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Update Bio", showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Years in Business"),
                  CustomTextField(
                    hint: "e.g. 5 Years",
                    controller: businessYearsController,
                    keyboard: TextInputType.number,
                  ),

                  _gap(),

                  _label("Previous Type of Job"),
                  CustomTextField(
                    hint: "e.g. Software Engineer",
                    controller: previousJobController,
                  ),

                  _gap(),

                  _label("Current Job / Business Type"),
                  CustomTextField(
                    hint: "e.g. Entrepreneur, Trader",
                    controller: jobTypeController,
                  ),

                  _gap(),

                  _label("Spouse / Children"),
                  CustomTextField(
                    hint: "e.g. Married, 2 Children",
                    controller: spouseChildrenController,
                  ),

                  _gap(),

                  _label("Pets"),
                  CustomTextField(
                    hint: "e.g. Dog, Cat, None",
                    controller: petsController,
                  ),

                  _gap(),

                  _label("Hobbies"),
                  CustomTextField(
                    hint: "e.g. Gym, Reading, Trading",
                    controller: hobbiesController,
                  ),

                  _gap(),

                  _label("City of Residence"),
                  CustomTextField(
                    hint: "e.g. Jaipur",
                    controller: cityController,
                  ),

                  _gap(),

                  _label("Years in This City"),
                  CustomTextField(
                    hint: "e.g. 10 Years",
                    controller: cityYearsController,
                    keyboard: TextInputType.number,
                  ),

                  _gap(),

                  _label("Business Desire"),
                  CustomTextField(
                    hint: "What do you want to achieve?",
                    controller: businessDesireController,
                    maxLines: 3,
                  ),

                  _gap(),

                  _label("Something No One Knows About Me"),
                  CustomTextField(
                    hint: "Share something unique",
                    controller: secretController,
                    maxLines: 3,
                  ),

                  _gap(),

                  _label("My Key to Success"),
                  CustomTextField(
                    hint: "What makes you successful?",
                    controller: successController,
                    maxLines: 3,
                  ),

                  const SizedBox(height: 30),

                  CustomButton(
                    text: "Update Bio",
                    onTap: () async {
                      if (userSno == null || userData == null) return;

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
                        "business_category": jobTypeController.text,
                        "business_registration_no":
                            userData!["business_registration_no"],
                        "business_address": userData!["business_address"],
                        "business_website": userData!["business_website"],
                        "social_media_link": userData!["social_media_link"],
                        "business_year": businessYearsController.text,
                        "previous_job": previousJobController.text,
                        "spouse_children": spouseChildrenController.text,
                        "pets": petsController.text,
                        "hobbies": hobbiesController.text,
                        "city_residence": cityController.text,
                        "city_year": cityYearsController.text,
                        "business_desire": businessDesireController.text,
                        "something_aboutme": secretController.text,
                        "keyto_success": successController.text,
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
                          const SnackBar(content: Text("Bio Updated")),
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
