import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';


class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Settings",
        showBackButton: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _tile("Notifications"),
          _tile("Change Password"),
          _tile("Privacy Settings"),
          _tile("Language"),
        ],
      ),
    );
  }

  Widget _tile(String title) {
    return ListTile(
      title: Text(
        title,
        style: GoogleFonts.kumbhSans(fontWeight: FontWeight.w600),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
    );
  }
}
