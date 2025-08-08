import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 40),

                Image.asset(
                  ConstantAssets.imgOnboarding,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.contain,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    'Fake jobs?\nNot on our watch!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.epilogue(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 30,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(bottom: 8, left: 8, right: 8),
                  child: Text(
                    'Protect yourself from fake job scams and find your dream job with confidence. Secure your job search with JobGuard',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.epilogue(
                      textStyle: Theme.of(context).textTheme.displayLarge,
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Color.fromRGBO(94, 94, 94, 1)
                    ),
                  ),
                ),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: (){
                        Get.toNamed(Routes.LOGIN);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)
                        ),
                        padding: EdgeInsets.symmetric(vertical: 16)
                      ),
                      child: Text(
                        'Get Started',
                        style: GoogleFonts.epilogue(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 16,
                          fontWeight: FontWeight.w500
                        ),
                      )
                  ),
                ),
                SizedBox(height: 24,)
              ],
            ),
          )
      )
    );
  }
}
