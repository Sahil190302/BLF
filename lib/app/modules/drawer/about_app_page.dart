import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';

class AboutAppPage extends StatelessWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "About Us",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// APP HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(.9),
                    AppColors.red.withOpacity(.9)
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.groups, size: 60, color: Colors.white),
                  const SizedBox(height: 10),

                  Text(
                    "BLF: Know, Connect, Grow",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.kumbhSans(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Connect with BLF members, share referrals, and grow your business network.",
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
              title: "Welcome",
              content:
                  "Welcome to BLF: Know, Connect & Grow – the official platform for members of the BLF mentorship program.\n\nBLF is more than just a networking group – it’s a community of growth-driven entrepreneurs committed to helping each other succeed. This app simplifies networking, strengthens relationships, and unlocks new business opportunities.",
            ),

            _sectionCard(
              title: "What is BLF",
              bullets: [
                "BLF is a non-profit business organization focused on ethical growth and collaboration.",
                "All contributions are utilized for member development and activities.",
                "No personal financial benefits are taken by the core team.",
                "Financial records are maintained and audited for transparency."
              ],
            ),

            _sectionCard(
              title: "Vision & Mission",
              bullets: [
                "Create a trusted, ethical and growth-oriented business community.",
                "Connect meaningfully",
                "Collaborate effectively",
                "Grow sustainably",
                "Follow the principle of 'Givers Gain'."
              ],
            ),

            _sectionCard(
              title: "Key Features",
              bullets: [
                "Member Networking – Connect with verified BLF members",
                "Referral Sharing – Exchange and track referrals",
                "Learning & Mentorship – Access growth sessions",
                "Meeting Management – Event and meeting updates",
                "Business Visibility – Promote your services"
              ],
            ),

            _sectionCard(
              title: "The BLF Advantage",
              bullets: [
                "Strong trust-based community",
                "Structured networking",
                "Continuous business learning",
                "Every member acts as a growth partner"
              ],
            ),

            _sectionCard(
              title: "Membership Guidelines",
              bullets: [
                "Monthly Meeting: 2nd Saturday every month",
                "Minimum Age: 25 years",
                "Minimum Business Experience: 5 years",
                "Maximum 2 members per business category"
              ],
            ),

            _sectionCard(
              title: "Financial Structure",
              bullets: [
                "₹5,100 – Registration Fee",
                "₹12,000 – Annual Contribution",
                "Total: ₹17,100 per year",
                "Referral earnings contribution is voluntary"
              ],
            ),

            _sectionCard(
              title: "Message from the Core Team",
              content:
                  "BLF is a family built on trust, contribution and growth.\n\nThe more you give, the more you grow.\n\nLet’s connect, collaborate and rise together.",
            ),

            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    String? content,
    List<String>? bullets,
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
                          )
                        ],
                      ),
                    ),
                  )
                  .toList(),
            )
        ],
      ),
    );
  }
}