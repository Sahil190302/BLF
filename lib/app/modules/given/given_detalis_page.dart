import 'package:blf/app/modules/given/given_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';

class GivenDetalisPage extends StatelessWidget {
  GivenDetalisPage({super.key});

  final GivenController c = Get.put(GivenController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "TYFCB Slip",showBackButton: true,),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(c),
                const SizedBox(height: 20),
                _buildThankYou(c),
                const SizedBox(height: 20),
                _buildAmountBox(c),
                const SizedBox(height: 16),
                _buildTypeRow(c),
                const SizedBox(height: 16),
                _buildComments(c),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildHeader(GivenController c) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.darkgreen,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.handshake, color: Colors.white),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From: ${c.fromName.value}",
                style: GoogleFonts.kumbhSans(
                    color: AppColors.white, fontWeight: FontWeight.w600),
              ),
              Text(
                "Date: ${c.date.value}",
                style: GoogleFonts.kumbhSans(
                    color: Colors.white70, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThankYou(GivenController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Thank you to:", style: GoogleFonts.kumbhSans(fontSize: 14)),
        const SizedBox(height: 8),
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage("https://images.unsplash.com/photo-1438761681033-6461ffad8d80?q=80&w=1170&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  c.thankYouName.value,
                  style: GoogleFonts.kumbhSans(
                      fontSize: 16, fontWeight: FontWeight.w700),
                ),
                Text(
                  c.company.value,
                  style: GoogleFonts.kumbhSans(fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildAmountBox(GivenController c) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          "₹ ${c.referralAmount.value}",
          style: GoogleFonts.kumbhSans(
              fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.white),
        ),
      ),
    );
  }

  Widget _buildTypeRow(GivenController c) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildTypeItem("Business Type", c.businessType.value),
        _buildTypeItem("Referral Type", c.referralType.value),
      ],
    );
  }

  Widget _buildTypeItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.kumbhSans(
                fontSize: 14, fontWeight: FontWeight.w500, color:AppColors.textLight)),
        const SizedBox(height: 4),
        Text(value,
            style:
            GoogleFonts.kumbhSans(fontSize: 16, fontWeight: FontWeight.w700)),
      ],
    );
  }

  Widget _buildComments(GivenController c) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Comments:",
            style: GoogleFonts.kumbhSans(
                fontSize: 14, fontWeight: FontWeight.w500, color:AppColors.textLight)),
        const SizedBox(height: 6),
        Text(c.comments.value,
            style: GoogleFonts.kumbhSans(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }

}
