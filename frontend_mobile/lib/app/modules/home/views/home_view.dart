import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/modules/home/widgets/menu_card.dart';
import 'package:frontend_mobile/app/modules/home/widgets/profile_menu.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Greeting & Avatar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Good Morning",
                        style: GoogleFonts.epilogue(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Obx(() {
                        final user = controller.userController.user;
                        return Text(
                          user?.username ?? "User",
                          style: GoogleFonts.epilogue(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ],
                  ),
                  ProfileMenu()
                ],
              ),
              const SizedBox(height: 30),

              // Title
              Text(
                "How Can I Help You\nToday ?",
                style: GoogleFonts.epilogue(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 24),

              // 3 Menu Cards
              MenuCard(),

              const SizedBox(height: 24),

              // Recent Activity
              Text(
                "Recent Activity",
                style: GoogleFonts.epilogue(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // Add ListView or Placeholder here
              const SizedBox(height: 8),
              Expanded(
                child: Center(
                  child: Text(
                    "No recent activity",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
