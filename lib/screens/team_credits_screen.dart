import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/team_member.dart';
import '../widgets/team_member_card.dart';
import '../widgets/gradient_background.dart';

class TeamCreditsScreen extends StatelessWidget {
  const TeamCreditsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final teamMembers = TeamData.getTeamMembers();

    return Scaffold(
      appBar: AppBar(
        title: Text('Team Credits', style: GoogleFonts.poppins(fontSize: 20.sp)),
        centerTitle: true,
      ),
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Text(
                  'Meet Our Team',
                  style: GoogleFonts.poppins(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 20.h),
                Expanded(
                  child: ListView.builder(
                    itemCount: teamMembers.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: TeamMemberCard(member: teamMembers[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}