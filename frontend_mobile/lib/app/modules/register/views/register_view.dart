import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.white,
        body: Stack(
          children: [
            Positioned.fill(
                child: Image.asset(
                  ConstantAssets.imgBg,
                  fit: BoxFit.cover,
                )
            ),
            SingleChildScrollView(
                child: SafeArea(
                    child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 120, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'New here? Let’s\nget started!',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.epilogue(
                          textStyle: Theme.of(context).textTheme.displayLarge,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8,),
                      Text(
                        'Join now to detect scams, learn from real examples, and build your CV with ease.',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.epilogue(
                            textStyle: Theme.of(context).textTheme.displayLarge,
                            fontSize: 13,
                            color: Color.fromRGBO(94, 94, 94, 1)
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 100, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Username',
                              style: GoogleFonts.epilogue(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 5,),
                            TextField(
                              controller: controller.usernameController,
                              decoration: InputDecoration(
                                hintText: "enter your username",
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
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Email',
                              style: GoogleFonts.epilogue(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 5,),
                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                hintText: "info@example.com",
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
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password',
                              style: GoogleFonts.epilogue(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 5,),
                            Obx(() => TextField(
                              controller: controller.passwordController,
                              obscureText: !controller.isPasswordVisible.value,
                              onChanged: (_) => controller.validatePasswords(),
                              decoration: InputDecoration(
                                hintText: "********",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(183, 183, 183, 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isPasswordVisible.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color: const Color.fromRGBO(183, 183, 183, 1.0),
                                  ),
                                  onPressed: () {
                                    controller.isPasswordVisible.toggle();
                                  },
                                ),
                              ),
                            )),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 50),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirm Password',
                              style: GoogleFonts.epilogue(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(height: 5,),
                            Obx(() => TextField(
                              controller: controller.confirmPasswordController,
                              obscureText: !controller.isConfirmPasswordVisible.value,
                              onChanged: (_) => controller.validatePasswords(),
                              decoration: InputDecoration(
                                hintText: "********",
                                hintStyle: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(183, 183, 183, 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(color: Color.fromRGBO(216, 224, 167, 1.0)),
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    controller.isConfirmPasswordVisible.value
                                        ? CupertinoIcons.eye
                                        : CupertinoIcons.eye_slash,
                                    color: const Color.fromRGBO(183, 183, 183, 1.0),
                                  ),
                                  onPressed: () {
                                    controller.isConfirmPasswordVisible.toggle();
                                  },
                                ),
                              ),
                            )),
                            Obx(() {
                              return controller.isPasswordMismatch.value
                                  ? const Padding(
                                padding: EdgeInsets.only(top: 4),
                                child: Text(
                                  "Password tidak cocok",
                                  style: TextStyle(color: Color.fromRGBO(200, 111, 111, 1.0), fontSize: 12),
                                ),
                              )
                                  : const SizedBox.shrink();
                            }),
                            SizedBox(height: 5,),
                          ],
                        ),
                      ),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: (){
                              controller.register();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                padding: EdgeInsets.symmetric(vertical: 16)
                            ),
                            child: Text(
                              'Sign up',
                              style: GoogleFonts.epilogue(
                                  textStyle: Theme.of(context).textTheme.displayLarge,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            )
                        ),
                      ),
                      SizedBox(height: 50,),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: GoogleFonts.epilogue(
                              textStyle: Theme.of(context).textTheme.displayLarge,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(94, 94, 94, 1),
                            ),
                            children: [
                              const TextSpan(text: "Already have an account? "),
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(
                                  color: Color.fromRGBO(150, 157, 105, 1.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Get.toNamed(Routes.LOGIN);
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                )
                )
            )
          ],
        )
    );
  }
}
