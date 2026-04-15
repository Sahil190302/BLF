import 'package:blf/app/Customwidget/Homewidget.dart';
import 'package:blf/app/Customwidget/website_footer.dart';
import 'package:blf/app/modules/OneToOneMeeting/one_to_one_meeting_view.dart';
import 'package:blf/app/modules/TYFCB/tyfcb_view.dart';
import 'package:blf/app/services/app_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import '../../../widgets/Custom_Drawer.dart';
import '../../../widgets/custom_appbar.dart';
import '../outsidereferral/outside_referral_view.dart';
import 'home_controller.dart';

class HomeScreen extends StatelessWidget {
  final GlobalKey<ScaffoldState>
  scaffoldKey; // changed from optional to required

  const HomeScreen({
    super.key,
    required this.scaffoldKey,
  }); // constructor updated

  @override
  Widget build(BuildContext context) {
    if (AppSession.token == null) {
      Future.microtask(() => Get.offAllNamed('/login'));
      return const SizedBox();
    }
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.white,
      appBar: CustomAppBar(
        showNotification: true,
        title: "Home",
        leadingIcon: Icons.menu,
        scaffoldKey: scaffoldKey, // pass   the same key
      ),
      drawer: const CustomDrawerWidget(),

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshHome,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeaderSection(controller: controller),
                const SizedBox(height: 10),
                UpcomingEventsSection(events: controller.upcomingEvents),

                const SizedBox(height: 20),
                ThisWeeksSlipsSection(controller: controller),
                const SizedBox(height: 10),
                TimePeriodSection(controller: controller),
                const SizedBox(height: 20),
                NextMeetingSection(controller: controller),
                const SizedBox(height: 20),
                QuickActionsSection(),
                const SizedBox(height: 20),
                const WebsiteFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
