import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Terms of Service",
        showBackButton: true,
      ),
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
                  const Icon(Icons.gavel, size: 60, color: Colors.white),
                  const SizedBox(height: 10),

                  Text(
                    "BLF Terms of Service",
                    style: GoogleFonts.kumbhSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Guidelines and conditions for using the BLF platform.",
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
              title: "Acceptance of Terms",
              bullets: [
                "By downloading, accessing, or using BLF: Know, Connect & Grow, you agree to comply with these Terms of Service.",
                "If you do not agree with these terms, please do not use the application."
              ],
            ),

            _sectionCard(
              title: "About BLF",
              bullets: [
                "BLF is a non-profit business networking organization.",
                "It supports collaboration, referrals and professional growth among members.",
                "The mobile app provides networking, communication and activity tracking."
              ],
            ),

            _sectionCard(
              title: "Member Eligibility",
              bullets: [
                "Membership is subject to approval by the BLF core team",
                "Minimum age: 25 years",
                "Minimum 5 years of business experience",
                "Family businesses may qualify with 3+ years experience (subject to review)",
                "Members must maintain ethical business practices",
                "BLF may limit members within specific business categories"
              ],
            ),

            _sectionCard(
              title: "Account Responsibility",
              bullets: [
                "Maintain confidentiality of your account",
                "All activities under your account are your responsibility",
                "Provide accurate and up-to-date information"
              ],
            ),

            _sectionCard(
              title: "Membership Fees & Payments",
              bullets: [
                "Membership may involve registration or participation fees",
                "Annual or event-related contributions may apply",
                "All fees will be communicated before payment"
              ],
            ),

            _sectionCard(
              title: "Participation Guidelines",
              bullets: [
                "Attend scheduled meetings and events",
                "Engage in networking and referral activities",
                "Update attendance status in the app when required",
                "Participation levels may be reviewed by BLF"
              ],
            ),

            _sectionCard(
              title: "Code of Conduct",
              bullets: [
                "Follow ethical and honest business practices",
                "Respect other members and maintain professional behavior",
                "Avoid fraudulent, misleading or harmful activities",
                "Contribute positively to the BLF community"
              ],
            ),

            _sectionCard(
              title: "Content & Platform Usage",
              bullets: [
                "You retain ownership of the content you share",
                "BLF receives limited license to display content within the platform",
                "Uploading unlawful or misleading content is prohibited"
              ],
            ),

            _sectionCard(
              title: "Suspension or Termination",
              bullets: [
                "BLF may suspend or terminate access if terms are violated",
                "Unethical or harmful behavior may lead to action",
                "Platform misuse may result in termination",
                "Decisions are at the discretion of BLF management"
              ],
            ),

            _sectionCard(
              title: "Data & Privacy",
              content:
                  "Your use of the platform is also governed by the BLF Privacy Policy. Please review it to understand how your information is handled.",
            ),

            _sectionCard(
              title: "Limitation of Liability",
              bullets: [
                "BLF does not guarantee business outcomes or referral success",
                "BLF does not guarantee financial gains",
                "BLF does not verify accuracy of member-provided information",
                "Members interact with each other at their own responsibility"
              ],
            ),

            _sectionCard(
              title: "Changes to Terms",
              content:
                  "BLF may update these Terms of Service from time to time. Continued use of the app after updates means you accept the revised terms.",
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
    final Uri emailUri =
        Uri.parse("mailto:official@blf.co.in?subject=BLF Support");

    await launchUrl(emailUri, mode: LaunchMode.externalApplication);
  }

  Future<void> _launchWebsite() async {
    final Uri webUri = Uri.parse("https://www.blf.co.in");

    await launchUrl(webUri, mode: LaunchMode.externalApplication);
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
          )
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

          if (child != null) ...[
            const SizedBox(height: 8),
            child,
          ],
        ],
      ),
    );
  }
}