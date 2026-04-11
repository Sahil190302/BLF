import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/app_colors.dart';
import '../../../../widgets/custom_appbar.dart';
import '../../search/search_model.dart';

class ConnectionProfileView extends StatelessWidget {
  final SearchUser user;

  const ConnectionProfileView({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: "Profile", showBackButton: true),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// PROFILE HEADER
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
         CircleAvatar(
  radius: 45,
  backgroundColor: Colors.grey.shade200,
  child: user.image.isEmpty
      ? const Icon(
          Icons.person,
          size: 50,
          color: Colors.grey,
        )
      : Builder(
          builder: (context) {
            final imageUrl = user.image.startsWith("http")
                ? user.image
                : "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/${user.image}";

            return ClipOval(
              child: Image.network(
                imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.person,
                    size: 50,
                    color: Colors.grey,
                  );
                },
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  );
                },
              ),
            );
          },
        ),
),

                    const SizedBox(height: 10),

                    Text(
                      user.name,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      user.category,
                      style: GoogleFonts.kumbhSans(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // _iconButton(Icons.call),
                        // _iconButton(Icons.email),
                        // _iconButton(Icons.share),
                        // _iconButton(Icons.event_note),
                        // _iconButton(Icons.more_horiz),
                      ],
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              /// CONTACT INFO
              _infoTile(Icons.location_on, user.city),
              _infoTile(Icons.call, user.phone),
              _infoTile(Icons.email, user.email),

              const SizedBox(height: 20),

              /// BUSINESS SECTION
              _sectionTitle("MY BUSINESS"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  user.businessName,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.kumbhSans(fontSize: 13),
                ),
              ),

              const SizedBox(height: 25),

              /// ABOUT
              _sectionTitle("ABOUT"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  user.about,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.kumbhSans(fontSize: 13),
                ),
              ),

              const SizedBox(height: 25),

              /// HOBBIES
              _sectionTitle("HOBBIES"),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  user.hobbies,
                  style: GoogleFonts.kumbhSans(fontSize: 13),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6),
      height: 44,
      width: 44,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primary,
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  Widget _infoTile(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(text, style: GoogleFonts.kumbhSans(fontSize: 13)),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: GoogleFonts.kumbhSans(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }
}
