import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:frontend_mobile/app/routes/app_pages.dart';
import 'package:frontend_mobile/utils/constant_asset.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      'Good to see you\nagain!',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.epilogue(
                        textStyle: Theme.of(context).textTheme.displayLarge,
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 8,),
                    Text(
                      'Sign in to detect fake job postings, learn how to avoid scams, and create a standout CV — all in one place.',
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
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
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
                            obscureText: controller.obscurePassword.value,
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
                                  controller.obscurePassword.value
                                      ? CupertinoIcons.eye_slash
                                      : CupertinoIcons.eye,
                                  color: const Color.fromRGBO(
                                      119, 119, 119, 1.0),
                                ),
                                onPressed: controller.togglePasswordVisibility,
                              ),
                            ),
                          )),
                          SizedBox(height: 5,),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Forget Password ?',
                              style: GoogleFonts.epilogue(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Color.fromRGBO(94, 94, 94, 1),
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
                            controller.login();
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(216, 224, 167, 1.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                              ),
                              padding: EdgeInsets.symmetric(vertical: 16)
                          ),
                          child: Text(
                            'Sign in',
                            style: GoogleFonts.epilogue(
                                textStyle: Theme.of(context).textTheme.displayLarge,
                                fontSize: 16,
                                fontWeight: FontWeight.w500
                            ),
                          )
                      ),
                    ),
                    SizedBox(height: 250,),
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
                            const TextSpan(text: "Don’t have an account? "),
                            TextSpan(
                              text: "Sign Up",
                              style: TextStyle(
                                color: Color.fromRGBO(150, 157, 105, 1.0),
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Get.toNamed(Routes.REGISTER);
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
