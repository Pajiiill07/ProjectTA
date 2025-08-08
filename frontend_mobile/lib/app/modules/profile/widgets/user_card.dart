import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/data/controller/datauser_controller.dart';
import 'package:frontend_mobile/app/data/controller/user_controller.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UserCard extends StatelessWidget {
  const UserCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dataUserController = Get.find<DataUserController>();
    final userController = Get.find<UserController>();

    return Obx((){
      final dataUser = dataUserController.dataUser;
      final user = userController.user;
      final photoUrl = user?.photoUrl;

      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            border: Border.fromBorderSide(
                BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)
                )
            )
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey[300],
              backgroundImage: _getProfileImage(photoUrl),
              child: user == null
                  ? Icon(Icons.person, color: Colors.grey[600])
                  : null,
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    (dataUser?.namaLengkap?.isNotEmpty ?? false)
                        ? '${dataUser!.namaLengkap} (${user?.username ?? "-"})'
                        : (user?.username ?? "-"),
                    style: GoogleFonts.epilogue(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                      user?.email ?? "-",
                      style: GoogleFonts.epilogue(
                          fontSize: 13,
                          color: Color.fromRGBO(152, 152, 152, 1.0)
                      )
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 80,
              child: ElevatedButton(
                  onPressed: (){
                    Get.toNamed(Routes.EDIT_USER);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(253, 255, 241, 1.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                          side: BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0))
                      ),
                      padding: EdgeInsets.symmetric(vertical: 10)
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.mode_edit_outline_outlined, size: 16, color: Color.fromRGBO(45, 43, 40, 1.0)),
                      SizedBox(width: 8,),
                      Text(
                        'Edit',
                        style: GoogleFonts.epilogue(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color.fromRGBO(45, 43, 40, 1.0)
                        ),
                      ),
                    ],
                  )
              ),
            ),
          ],
        ),
      );
    });
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
