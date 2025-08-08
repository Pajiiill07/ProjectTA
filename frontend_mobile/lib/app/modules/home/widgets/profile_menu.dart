import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/auth_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileMenu extends StatelessWidget {
  const ProfileMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          Get.toNamed(Routes.PROFILE);
        } else if (value == 'logout') {
          final authController = Get.find<AuthController>();
          authController.logout();
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'edit',
          child: Row(
            children: [
              Icon(Icons.person_2_outlined, color: Color.fromRGBO(45, 43, 40, 1.0), size: 18,),
              SizedBox(width: 10,),
              Text(
                  'Edit Profile',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, color: Color.fromRGBO(200, 111, 111, 1.0), size: 18,),
              SizedBox(width: 10,),
              Text(
                  'Logout',
                style: GoogleFonts.epilogue(
                  fontSize: 14,
                  color: Color.fromRGBO(200, 111, 111, 1.0),
                  fontWeight: FontWeight.w500
                ),
              ),
            ],
          ),
        ),
      ],
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Obx(() {
        final user = Get.find<UserController>().user;
        final photoUrl = user?.photoUrl;

        return CircleAvatar(
          radius: 25,
          backgroundColor: Colors.grey[300],
          backgroundImage: _getProfileImage(photoUrl),
          child: user == null
              ? Icon(Icons.person, color: Colors.grey[600])
              : null,
        );
      }),
    );
  }

  ImageProvider? _getProfileImage(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty || photoUrl == "null") {
      return const NetworkImage("http://192.168.18.51:8000/static/upload/default.jpeg");
    }

    if (photoUrl.startsWith('http')) {
      return NetworkImage(photoUrl);
    }

    return NetworkImage("http://192.168.18.51:8000$photoUrl");
  }
}
