  import 'package:blf/app/modules/Community/Events/event_details_page.dart';
import 'package:blf/utils/app_colors.dart';
  import 'package:blf/widgets/custom_appbar.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';
  import 'package:google_fonts/google_fonts.dart';

  class UpcomingEvents extends StatelessWidget {
    const UpcomingEvents({super.key});

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: CustomAppBar(title: "Upcoming Events", showBackButton: true),
        body: ListView.builder(
          itemCount: 10,
          padding: EdgeInsets.all(10),
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(5.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EventDetailsPage(),
                    ),
                  );
                },
                child: Container(
                  // height: 100,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Indin Executive Director Training Goa",
                          maxLines: 1,
                          style: GoogleFonts.kumbhSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.red,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_sharp,
                              color: AppColors.textLight,
                              size: 15,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "To Be Announced",
                              maxLines: 1,
                              style: GoogleFonts.kumbhSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                        Row(
                          children: [
                            Icon(
                              Icons.date_range,
                              color: AppColors.textLight,
                              size: 15,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "10 July 10:00 AM",
                              maxLines: 1,
                              style: GoogleFonts.kumbhSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textLight,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5),
                
                        Row(
                          children: [
                            Icon(
                              Icons.language,
                              color: AppColors.textLight,
                              size: 15,
                            ),
                            SizedBox(width: 10),
                            Text(
                              "Asia/kolkata",
                              maxLines: 1,
                              style: GoogleFonts.kumbhSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w300,
                                color: AppColors.textLight,
                              ),
                            ),
                            Spacer(),
                            Container(
                              height: 25,
                              width: 100,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: AppColors.red,borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                "Register Now",
                                style: GoogleFonts.kumbhSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }
