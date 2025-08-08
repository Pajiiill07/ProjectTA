import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/deteksi_controller.dart';

class DeteksiView extends GetView<DeteksiController> {
  const DeteksiView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(
            'Job Detect',
          style: GoogleFonts.epilogue(
            fontWeight: FontWeight.w500,
            fontSize: 20
          ),
        ),
        actions: [
          IconButton(
              onPressed: (){
                Get.toNamed(Routes.HISTORY_DETEKSI);
              },
              icon: Icon(Icons.history)
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Job Detection',
                  style: GoogleFonts.epilogue(
                    fontSize: 22,
                    fontWeight: FontWeight.w600
                  ),
                ),
                Text(
                  'Enter the job posting text you want to check! Our system will analyze and detect if its potentially fake or no.',
                  style: GoogleFonts.epilogue(
                    fontSize: 14,
                    color: Color.fromRGBO(148, 148, 148, 1.0)
                  ),
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(0, 50, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Judul Lowongan',
                        style: GoogleFonts.epilogue(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        // controller: controller.emailController,
                        decoration: InputDecoration(
                          hintText: "judul/ posisi lowongan",
                          hintStyle: GoogleFonts.epilogue(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 13,
                              color: Color.fromRGBO(183, 183, 183, 1.0)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Nama Perusahaan',
                        style: GoogleFonts.epilogue(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        // controller: controller.emailController,
                        decoration: InputDecoration(
                          hintText: "nama perusahaan",
                          hintStyle: GoogleFonts.epilogue(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 13,
                              color: Color.fromRGBO(183, 183, 183, 1.0)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Deskripsi Pekerjaan',
                        style: GoogleFonts.epilogue(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 14,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                      SizedBox(height: 5,),
                      TextField(
                        // controller: controller.emailController,
                        maxLines: 5,
                        decoration: InputDecoration(
                          hintText: "deskripsi pekerjaan (persyaratan,dll)",
                          hintStyle: GoogleFonts.epilogue(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 13,
                              color: Color.fromRGBO(183, 183, 183, 1.0)
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){

                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)
                          ),
                          padding: EdgeInsets.symmetric(vertical: 16)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_outlined, size: 20, color: Colors.black,),
                          Text(
                            'Check',
                            style: GoogleFonts.epilogue(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          ),
                        ],
                      )
                  ),
                ),
              ],
            ),
          )
      )
    );
  }
}
