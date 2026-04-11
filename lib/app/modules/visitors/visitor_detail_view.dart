import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';

class VisitorDetailView extends StatelessWidget {
  final Map<String, dynamic> visitor;

  const VisitorDetailView({super.key, required this.visitor});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppBar(title: "Visitor Details",showBackButton: true,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            _profileCard(),

            const SizedBox(height: 15),

            _infoCard("Business Information", Icons.business, [
              _tile("Business Name", visitor["business_name"]),
              _tile("Category", visitor["business_category"]),
              _tile("Website", visitor["business_website"]),
              _tile("Years in Business", visitor["business_year"]),
            ]),

            const SizedBox(height: 15),

            _infoCard("Contact Information", Icons.phone, [
              _tile("Email", visitor["email"]),
              _tile("Mobile", visitor["mobile"]),
              _tile("Address", visitor["business_address"]),
            ]),

            const SizedBox(height: 15),

            _infoCard("Other Details", Icons.info, [
              _tile("Group Member", visitor["koi_group_ke_member_ho"]),
              _tile("Join Date", visitor["date"]),
            ]),

          ],
        ),
      ),
    );
  }

  Widget _profileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryDark,
            AppColors.darkgreen
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [

          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.primaryDark,
            ),
          ),

          const SizedBox(height: 12),

          Text(
            visitor["name"] ?? "",
            style: GoogleFonts.kumbhSans(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            visitor["business_category"] ?? "",
            style: GoogleFonts.kumbhSans(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(String title, IconData icon, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, color: AppColors.primaryDark),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.kumbhSans(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          const Divider(),

          ...children
        ],
      ),
    );
  }

  Widget _tile(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [

          Expanded(
            flex: 3,
            child: Text(
              label,
              style: GoogleFonts.kumbhSans(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(
              value ?? "-",
              style: GoogleFonts.kumbhSans(),
            ),
          ),
        ],
      ),
    );
  }
}