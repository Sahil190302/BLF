import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blf/utils/app_colors.dart';
import 'package:blf/widgets/custom_appbar.dart';
import 'package:blf/widgets/custom_button.dart';

class LeaveRatingPage extends StatefulWidget {
  const LeaveRatingPage({super.key});

  @override
  State<LeaveRatingPage> createState() => _LeaveRatingPageState();
}

class _LeaveRatingPageState extends State<LeaveRatingPage> {
  int selectedRating = 0;
  final TextEditingController feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: const CustomAppBar(
        title: "Leave a Rating",
        showBackButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// TITLE
            Text(
              "How was your experience?",
              style: GoogleFonts.kumbhSans(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Your feedback helps us improve our app",
              style: GoogleFonts.kumbhSans(
                fontSize: 13,
                color: AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 30),

            /// STAR RATING
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = index + 1;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: 40,
                    color: index < selectedRating
                        ? Colors.amber
                        : Colors.grey.shade300,
                  ),
                );
              }),
            ),

            const SizedBox(height: 25),

            /// FEEDBACK FIELD
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Write your feedback (optional)",
                style: GoogleFonts.kumbhSans(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 6),

            TextField(
              controller: feedbackController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Tell us what you liked or what can be improved...",
                hintStyle:
                GoogleFonts.kumbhSans(color: AppColors.textLight),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: AppColors.red),
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// SUBMIT BUTTON
            CustomButton(
              text: "Submit Rating",
              onTap: () {
                if (selectedRating == 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please select a rating"),
                    ),
                  );
                  return;
                }

                // TODO: API call / backend submit
                debugPrint("Rating: $selectedRating");
                debugPrint("Feedback: ${feedbackController.text}");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Thank you for your feedback!"),
                  ),
                );

                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
