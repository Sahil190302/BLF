import 'package:blf/app/modules/more/update_bio_api.dart';
import 'package:blf/app/services/home_api.dart';
import 'package:blf/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';

class UpdateAddressPage extends StatefulWidget {
  const UpdateAddressPage({super.key});

  @override
  State<UpdateAddressPage> createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  final address1Controller = TextEditingController();
  final address2Controller = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final pincodeController = TextEditingController();

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

      address1Controller.text = user["address1"] ?? "";
      address2Controller.text = user["address2"] ?? "";
      cityController.text = user["city"] ?? "";
      stateController.text = user["state"] ?? "";
      pincodeController.text = user["pincode"] ?? "";

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
    address1Controller.dispose();
    address2Controller.dispose();
    cityController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(title: "Update Address", showBackButton: true),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _label("Address Line 1"),
                  _textField(address1Controller, "Enter address line 1"),

                  _label("Address Line 2"),
                  _textField(address2Controller, "Enter address line 2"),

                  _label("City"),
                  _textField(cityController, "Enter city"),

                  _label("State"),
                  _textField(stateController, "Enter state"),

                  _label("Pincode"),
                  _textField(
                    pincodeController,
                    "Enter pincode",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 30),

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
                        "address1": address1Controller.text,
                        "address2": address2Controller.text,
                        "city": cityController.text,
                        "state": stateController.text,
                        "pincode": pincodeController.text,
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
                          const SnackBar(content: Text("Address Updated")),
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
      padding: const EdgeInsets.only(bottom: 6, top: 12),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(fontSize: 14, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _textField(
    TextEditingController controller,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.kumbhSans(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.kumbhSans(color: AppColors.textLight),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: AppColors.red),
        ),
      ),
    );
  }
}
