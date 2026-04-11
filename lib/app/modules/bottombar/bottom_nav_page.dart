import 'package:blf/app/modules/Community/Testimonials/TestimonialsPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/app/modules/more/profile_view.dart';
import 'package:blf/app/modules/search/search_page.dart';
import 'package:blf/app/modules/slips/slips_page.dart';
import 'package:blf/app/modules/visitors/VisitorsView.dart';
import '../../../utils/app_colors.dart';
import 'bottom_nav_controller.dart';
import 'package:blf/app/modules/home/home_page.dart';

class BottomNavPage extends StatelessWidget {
  BottomNavPage({Key? key}) : super(key: key);

  final BottomNavController controller = Get.put(BottomNavController());
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _getCurrentPage() {
    switch (controller.selectedIndex.value) {
      case 0:
        return HomeScreen(scaffoldKey: _scaffoldKey); // Pass the scaffold key
      case 1:
        return TestimonialsPage();
      case 2:
        return SearchPageView();
      case 3:
        return VisitorsView();
      case 4:
        return ProfileView();
      default:
        return HomeScreen(scaffoldKey: _scaffoldKey);
    }
  }

  final List<NavItem> navItems = const [
    NavItem(icon: Icons.home, label: "Home"),
    NavItem(icon: Icons.receipt, label: "Slips"),
    NavItem(icon: Icons.search, label: "Search"),
    NavItem(icon: Icons.group, label: "Visitors"),
    NavItem(icon: Icons.menu, label: "More"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _getCurrentPage()),
      bottomNavigationBar: Obx(() => _buildCustomNavBar()),
    );
  }

  Widget _buildCustomNavBar() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white, // White background
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navItems.length, (index) {
          final item = navItems[index];
          final isSelected = controller.selectedIndex.value == index;
          return _buildNavItem(item, isSelected, index);
        }),
      ),
    );
  }

  Widget _buildNavItem(NavItem item, bool isSelected, int index) {
    return GestureDetector(
      onTap: () => controller.changeIndex(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                item.icon,
                size: 25,
                color: isSelected ? AppColors.primary : Colors.black,
              ),

              const SizedBox(height: 2),

              Text(
                item.label,
                style: GoogleFonts.kumbhSans(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// NavItem class
class NavItem {
  final IconData icon;
  final String label;

  const NavItem({required this.icon, required this.label});
}
