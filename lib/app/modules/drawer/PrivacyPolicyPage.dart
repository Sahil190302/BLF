import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(title: "Privacy Policy", showBackButton: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(.9),
                    AppColors.red.withOpacity(.9),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.privacy_tip, size: 60, color: Colors.white),
                  const SizedBox(height: 10),

                  Text(
                    "BLF Privacy Policy",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "How we collect, use and protect your information.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 13,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            _sectionCard(
              title: "Introduction",
              bullets: [
                "Welcome to BLF: Know, Connect and Grow.",
                "This privacy policy explains how we collect, use and protect your personal and business information when you use our mobile application.",
                "By using the app, you agree to the terms outlined in this policy.",
              ],
            ),

            _sectionCard(
              title: "Information We Collect",
              bullets: [
                "Personal & Profile Information:",
                "Full name",
                "Phone number and contact details",
                "Business name, category and profile details",
                "Activity & Performance Data:",
                "Meeting attendance records including absence reasons",
                "Referrals given and received",
                "Thank-you notes and engagement activity",
                "Business performance data shared within BLF network",
                "Device & Technical Information:",
                "Device type and operating system",
                "App usage diagnostics",
                "Log data for performance improvement",
              ],
            ),

            _sectionCard(
              title: "How We Use Your Information",
              bullets: [
                "Display your profile in the BLF member directory",
                "Enable networking and referral sharing",
                "Track and present performance metrics on dashboards",
                "Manage events, RSVPs and meeting updates",
                "Send notifications related to meetings and activities",
                "Improve application performance and user experience",
              ],
            ),

            _sectionCard(
              title: "Data Sharing & Visibility",
              bullets: [
                "BLF is a closed members-only networking platform",
                "Profile and business information may be visible to approved BLF members",
                "Attendance records and referral activities may be shared within the network",
                "We never sell, rent or trade your personal data to third parties",
                "Information may only be shared if legally required",
              ],
            ),

            _sectionCard(
              title: "Data Security",
              content:
                  "We implement industry-standard security practices to protect your data from unauthorized access, loss or misuse. However, no digital platform can guarantee absolute security, and users should use the platform responsibly.",
            ),

            _sectionCard(
              title: "Data Retention",
              content:
                  "Your information is retained while your membership is active or as required for operational and legal purposes. You may request deletion of your data at any time.",
            ),

            _sectionCard(
              title: "Your Rights",
              bullets: [
                "Access your personal data",
                "Update or correct your information",
                "Request deletion of your account and data",
                "Contact BLF support to exercise these rights",
              ],
            ),

            _sectionCard(
              title: "Children’s Privacy",
              content:
                  "BLF is intended for users aged 25 years and above. We do not knowingly collect data from individuals below this age.",
            ),

            _sectionCard(
              title: "Changes to this Policy",
              content:
                  "This privacy policy may be updated from time to time. Any changes will be reflected within the app or on our official platform.",
            ),

            _sectionCard(
              title: "Contact Us",
              child: Column(
                children: [
                  InkWell(
                    onTap: _launchEmail,
                    child: Row(
                      children: [
                        const Icon(Icons.email, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          "official@blf.co.in",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  InkWell(
                    onTap: _launchWebsite,
                    child: Row(
                      children: [
                        const Icon(Icons.language, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Text(
                          "www.blf.co.in",
                          style: GoogleFonts.kumbhSans(
                            fontSize: 14,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

 Future<void> _launchEmail() async {
  final Uri emailUri = Uri.parse(
    "mailto:official@blf.co.in?subject=BLF App Support",
  );

  await launchUrl(
    emailUri,
    mode: LaunchMode.externalApplication,
  );
}

 Future<void> _launchWebsite() async {
  final Uri webUri = Uri.parse("https://www.blf.co.in");

  await launchUrl(
    webUri,
    mode: LaunchMode.externalApplication,
  );
}

  Widget _sectionCard({
    required String title,
    String? content,
    List<String>? bullets,
    Widget? child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.kumbhSans(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.red,
            ),
          ),

          const SizedBox(height: 8),

          if (content != null)
            Text(
              content,
              style: GoogleFonts.kumbhSans(
                fontSize: 13,
                height: 1.6,
                color: AppColors.textDark,
              ),
            ),

          if (bullets != null)
            Column(
              children: bullets
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("• "),
                          Expanded(
                            child: Text(
                              e,
                              style: GoogleFonts.kumbhSans(
                                fontSize: 13,
                                height: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),

          if (child != null) ...[const SizedBox(height: 8), child],
        ],
      ),
    );
  }
}
