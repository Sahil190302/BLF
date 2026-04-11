import 'package:blf/widgets/custom_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/app_colors.dart';

class ReferralSlipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Referral Slip", showBackButton: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusSection(),
            const SizedBox(height: 25),

            _buildToSection(),
            const SizedBox(height: 25),

            _title("Referral Type"),
            _valueText("Inside"),
            const SizedBox(height: 25),

            _title("Referral Status"),
            _valueText("Given Your Card"),
            const SizedBox(height: 25),

            _title("Contact Details:"),
            const SizedBox(height: 12),
            _contactCardShadow(),
            const SizedBox(height: 15),

            _emailCardShadow(),
            const SizedBox(height: 25),

            _title("Comments"),
            const SizedBox(height: 10),
            _valueText("Rudra dev ji site"),
            const SizedBox(height :25),

            _title("How Hot Referral?"),
            const SizedBox(height: 10),
            _hotReferralLevels(),
            const SizedBox(height: 10),

          ],
        ),
      ),
    );
  }
  Widget _hotReferralLevels() {
    final levels = [
      "Cold",
      "Warm",
      "Hot",
      "Very Hot",
    ];

    return Wrap(
      spacing: 10,
      children: levels.map((level) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.red),
          ),
          child: Text(
            level,
            style: GoogleFonts.kumbhSans(
              fontWeight: FontWeight.w600,
              color: Colors.red,
            ),
          ),
        );
      }).toList(),
    );
  }


  // ---------------------------------------------------------------
  // STATUS SECTION
  // ---------------------------------------------------------------
  Widget _buildStatusSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Top Row (From + Eye Icon)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "From: Abhilash Joshi",
              style: GoogleFonts.kumbhSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            Icon(Icons.remove_red_eye, color: Colors.black, size: 28),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          "Date: 12/09/25",
          style: GoogleFonts.kumbhSans(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            Icon(Icons.circle, color: Colors.grey.shade400, size: 16),
            const SizedBox(width: 8),
            Text(
              "Not Contacted Yet",
              style: GoogleFonts.kumbhSans(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 4),

        Text(
          "December 09 2025",
          style: GoogleFonts.kumbhSans(
            color: Colors.black54,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // TO SECTION
  // ---------------------------------------------------------------
  Widget _buildToSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "To",
          style: GoogleFonts.kumbhSans(
            fontSize: 10,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(width: 10),

        ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Image.network(
            "https://images.unsplash.com/photo-1494790108377-be9c29b29330?fm=jpg&q=60&w=3000&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHx8MA%3D%3D",
            width: 55,
            height: 55,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 14),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rishabh Bansal",
              style: GoogleFonts.kumbhSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              "BLF Pinnacle",
              style: GoogleFonts.kumbhSans(
                color: Colors.black54,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------
  // TITLES
  // ---------------------------------------------------------------
  Widget _title(String text) {
    return Text(
      text,
      style: GoogleFonts.kumbhSans(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
    );
  }

  // ---------------------------------------------------------------
  // VALUE TEXT
  // ---------------------------------------------------------------
  Widget _valueText(String text) {
    return Text(
      text,
      style: GoogleFonts.kumbhSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    );
  }

  // ---------------------------------------------------------------
  // CONTACT CARD WITH DROPSHADOW
  // ---------------------------------------------------------------
  Widget _contactCardShadow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Abhilasha Joshi",
            style: GoogleFonts.kumbhSans(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),

          Row(
            children: [
              Icon(Icons.phone, color: Colors.red),
              const SizedBox(width: 8),
              Text(
                "+91**********",
                style: GoogleFonts.kumbhSans(
                  color: Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _emailCardShadow() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 4,
            spreadRadius: 0.5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.email, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "nirvanamodularsolutions@gmail.com",
                  style: GoogleFonts.kumbhSans(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            "B-19, B-Block, Goswami Marg,\n"
            "Malviya Nagar,\n"
            "Jaipur, Rajasthan, India,\n302017",
            style: GoogleFonts.kumbhSans(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
