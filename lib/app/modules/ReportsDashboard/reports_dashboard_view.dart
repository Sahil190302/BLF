import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart'; // For graphs
import '../../../utils/app_colors.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import 'reports_dashboard_controller.dart';

class ReportsDashboardView extends StatelessWidget {
  ReportsDashboardView({super.key});

  final ReportsDashboardController controller = Get.put(ReportsDashboardController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Reports & Analytics",
        showBackButton: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Member Performance"),
              _buildMemberChart(),

              const SizedBox(height: 20),
              _sectionTitle("Monthly/Quarterly Summary"),
              _buildSummaryCard(),

              const SizedBox(height: 20),
              _sectionTitle("Chapter Admin Statistics"),
              _buildAdminStats(),

              const SizedBox(height: 20),
              CustomButton(
                text: "Export to PDF/Excel",
                onTap: controller.exportReport,
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        text,
        style: GoogleFonts.kumbhSans(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.primaryDark,
        ),
      ),
    );
  }

  Widget _buildMemberChart() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Container(
        padding:  EdgeInsets.all(12),
        height: 250,
        child: SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          title: ChartTitle(text: 'Visitors / Meetings per Month', textStyle: GoogleFonts.kumbhSans()),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<PerformanceData, String>>[
            ColumnSeries<PerformanceData, String>(
              dataSource: controller.memberData,
              xValueMapper: (PerformanceData data, _) => data.month,
              yValueMapper: (PerformanceData data, _) => data.value,
              name: 'Performance',
              color: AppColors.primary,
            )
          ],

        ),
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Total Visitors: ${controller.totalVisitors.value}",
                  style: GoogleFonts.kumbhSans(fontSize: 14)),
              Text("Total Meetings: ${controller.totalMeetings.value}",
                  style: GoogleFonts.kumbhSans(fontSize: 14)),
              Text("Conversion Rate: ${controller.conversionRate.value}%",
                  style: GoogleFonts.kumbhSans(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildAdminStats() {
    return Column(
      children: controller.chapterStats.map((stat) =>
          Card(color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(stat.title, style: GoogleFonts.kumbhSans(
                        fontSize: 15, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Text(stat.details, style: GoogleFonts.kumbhSans(
                        fontSize: 14, color: Colors.grey[800])),
                  ],
                ),
              ),
            ),
          )).toList(),
    );
  }}