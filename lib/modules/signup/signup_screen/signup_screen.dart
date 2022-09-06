
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/signup/bloc/signup_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/components/components.dart';
import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../../login/screens/login_screen.dart';
import '../components/components.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  var emailKey = GlobalKey<FormState>();
  var phoneKey = GlobalKey<FormState>();

  bool emailFound(GlobalCubit cubit, String email) {
    bool x = false;
    cubit.globalUsers.forEach((element) {
      if (element.email == email) {
        x = true;
      }
    });
    return x;
  }

  static bool phoneNumberFound(GlobalCubit cubit, String phoneNumber) {
    bool x = false;
    cubit.globalUsers.forEach((element) {
      if (element.phoneNumber == phoneNumber ) {
        x = true;
      }
    });
    if(phoneNumber=="")x=false;
    return x;
  }

  @override
  Widget build(BuildContext context) {
    var cubit = SignupCubit.get(context);
    var globalCubit = GlobalCubit.get(context);
    SizeConfig.init(context);
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight:
                      SizeConfig.screenHeight! - SizeConfig.defaultSize! * 7,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Spacer(),
                        Container(
                            // color: Colors.red,
                            width: SizeConfig.screenWidth,
                            height: SizeConfig.screenHeight! / 5,
                            child: Image.asset('assets/profile.jpg')),
                        Row(
                          children: [
                            Expanded(
                                child: InkWell(
                              highlightColor: Colors.transparent,
                              radius: 0.0,
                              onTap: () {
                                cubit.changeSigninMethodIndex(0);
                              },
                              child: Container(
                                height: 50.0,
                                child: Center(
                                  child: Text(
                                    "PHONE",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: cubit.signinMethodIndex == 0
                                          ? WHITE
                                          : HINT_TEXT_COLOR,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    border: Border(
                                  bottom: BorderSide(
                                      width: 1.0,
                                      color: cubit.signinMethodIndex == 0
                                          ? WHITE
                                          : GREY),
                                )),
                              ),
                            )),
                            Expanded(
                                child: InkWell(
                              highlightColor: Colors.transparent,
                              radius: 0.0,
                              onTap: () {
                                cubit.changeSigninMethodIndex(1);
                              },
                              child: Container(
                                height: 50.0,
                                child: Center(
                                  child: Text(
                                    "EMAIL",
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: cubit.signinMethodIndex == 1
                                          ? WHITE
                                          : HINT_TEXT_COLOR,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    // color: Colors.red,
                                    border: Border(
                                  bottom: BorderSide(
                                    width: 1.0,
                                    color: cubit.signinMethodIndex == 1
                                        ? WHITE
                                        : GREY,
                                  ),
                                )),
                              ),
                            )),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize! * 2,
                        ),
                        if (cubit.signinMethodIndex == 1)
                          Form(
                            key: emailKey,
                            child: defaultTextField(
                              onChanged: (String? s) {},
                              hintText: 'Email',
                              controller: cubit.emailController,
                              validator: (String? value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(cubit.emailController.text);
                                if (!emailValid) {
                                  return "Invalid Email";
                                } else if (emailFound(
                                    globalCubit, cubit.emailController.text)) {
                                  return "Email is already exist";
                                }
                                return null;
                              },
                            ),
                          ),
                        if (cubit.signinMethodIndex == 1)
                          SizedBox(
                            height: SizeConfig.defaultSize! * 2,
                          ),
                        if (cubit.signinMethodIndex == 1)
                          defaultButton(
                              color: BUTTON_COLOR,
                              child: (state is SendOTPLoading)
                                  ? CircularProgressIndicator(
                                      color: WHITE,
                                      strokeWidth: 3.0,
                                    )
                                  : Text(
                                      'Next',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15.0,
                                      ),
                                    ),
                              function: () {
                                if (emailKey.currentState!.validate()) {
                                  cubit.sendOtpEmail(
                                      cubit.emailController.value.text,
                                      context);
                                }
                              }),
                        if (cubit.signinMethodIndex == 0)
                          Form(
                            key: phoneKey,
                            child: phoneField(
                              controller: cubit.phoneController,
                              context: context,
                              cubit: cubit,
                            ),
                          ),
                        if (cubit.signinMethodIndex == 0)
                          Text(
                            "you may receive SMS notifications from us for security and login purposes",
                            style: TextStyle(color: GREY, fontSize: 11.0),
                          ),
                        if (cubit.signinMethodIndex == 0)
                          SizedBox(
                            height: SizeConfig.defaultSize! * 2,
                          ),
                        if (cubit.signinMethodIndex == 0)
                          defaultButton(
                              child: Text(
                                'Next',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                              ),
                              function: () {
                                bool existPhoneNumber = phoneNumberFound(globalCubit, cubit.phoneNumber);
                                if (phoneKey.currentState!.validate() &&
                                    !existPhoneNumber) {
                                  print(cubit.phoneNumber);
                                  cubit
                                      .sendOTPPhoneNumber(
                                          cubit.phoneNumber, context)
                                      .then((value) {});
                                } else {

                                  if(existPhoneNumber){
                                       toastMessage(text: "Phone number is already exist", backgroundColor: GREY, textColor: WHITE,
                                  );
                                  }

                                }
                              }),
                        Spacer(
                          flex: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                color: GREY,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  AppNavigator.customNavigator(
                                      context: context,
                                      screen: LoginScreen(),
                                      finish: true);
                                },
                                child: Text(
                                  "Log in.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
