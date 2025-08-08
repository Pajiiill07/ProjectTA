import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuCard extends StatelessWidget {
  const MenuCard({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const gap = 16.0;
    final cardWidth = (screenWidth - gap - 32) / 2; // 16 padding left + right
    final cardHeight = cardWidth * 0.8;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      child: Column(
        children: [
          /// === Dua kartu horizontal ===
          Row(
            children: [
              // Detect Fake Job
              GestureDetector(
                onTap: (){
                  Get.toNamed(Routes.DETEKSI);
                },
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(209, 227, 227, 1.0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromRGBO(198, 215, 215, 1.0),
                            child: Icon(Icons.screen_search_desktop_outlined, size: 20, color: Color.fromRGBO(45, 43, 40, 1.0)),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Transform.rotate(
                              angle: 2.355, // 135 derajat
                              child: Icon(Icons.arrow_circle_left_outlined, size: 30, color: Color.fromRGBO(45, 43, 40, 1.0),),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Detect Fake\nJob',
                        style: GoogleFonts.epilogue(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 4),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: gap),

              // Build Your CV
              GestureDetector(
                onTap: (){
                  Get.offNamed(Routes.BUILD_HOME_CV);
                },
                child: Container(
                  width: cardWidth,
                  height: cardHeight,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(238, 244, 208, 1.0),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Color.fromRGBO(223, 228, 196, 1.0),
                            child: Icon(Icons.description, size: 20, color: Color.fromRGBO(45, 43, 40, 1.0)),
                          ),
                          Spacer(),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Transform.rotate(
                              angle: 2.355, // 135 derajat
                              child: Icon(Icons.arrow_circle_left_outlined, size: 30, color: Color.fromRGBO(45, 43, 40, 1.0),),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Text(
                        'Build Your CV',
                        style: GoogleFonts.epilogue(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: gap),

          /// === Education Content Full Width ===
          GestureDetector(
            onTap: (){
              Get.toNamed(Routes.KONTEN);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEEFE8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.black12,
                    child: Icon(Icons.lightbulb_outline_rounded, size: 20, color: Color.fromRGBO(45, 43, 40, 1.0)),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Education Content',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Transform.rotate(
                    angle: 2.355, // 135 derajat
                    child: Icon(Icons.arrow_circle_left_outlined, size: 30, color: Color.fromRGBO(45, 43, 40, 1.0)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
