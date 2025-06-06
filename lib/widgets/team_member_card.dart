import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/team_member.dart';
import '../utils/colors.dart';

class TeamMemberCard extends StatelessWidget {
  final TeamMember member;

  const TeamMemberCard({super.key, required this.member});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          gradient: Theme.of(context).brightness == Brightness.dark
              ? AppGradients.cardDark
              : AppGradients.cardLight,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.primaryBlue,
              child: member.photoUrl != null
                  ? ClipOval(
                child: Image.network(
                  member.photoUrl!,
                  width: 60.r,
                  height: 60.r,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.person,
                    size: 30.sp,
                    color: Colors.white,
                  ),
                ),
              )
                  : Icon(
                Icons.person,
                size: 30.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    member.name,
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    member.role,
                    style: GoogleFonts.inter(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Contribution: ${member.contributionPercentage}%',
                    style: GoogleFonts.inter(
                      fontSize: 12.sp,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}