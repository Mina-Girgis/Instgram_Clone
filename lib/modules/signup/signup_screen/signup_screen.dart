import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/modules/signup/bloc/signin_cubit.dart';
import 'package:pro/shared/components/components.dart';

import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../components/components.dart';
import 'package:email_auth/email_auth.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({Key? key}) : super(key: key);

  var emailController = TextEditingController();
  var emailKey = GlobalKey<FormState>();
  var phoneKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = SigninCubit.get(context);
    SizeConfig.init(context);
    return BlocConsumer<SigninCubit, SigninState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: SizeConfig.screenHeight! - 90,
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
                              onChanged: (String? s) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(s!);
                                // cubit.changeValidEmail(emailValid);
                              },
                              hintText: 'Email',
                              controller: emailController,
                              validator: (String? value) {
                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(emailController.text);
                                if (!emailValid) {
                                  return "Enter Valid Email";
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
                                  cubit.sendOtp(emailController.value.text);
                                }
                              }),
                        if (cubit.signinMethodIndex == 0) phoneField(),
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
                              function: () {}
                      ),
                        Spacer(),
                        Spacer(),
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
                                  print(WidgetsBinding
                                      .instance.window.locale.countryCode);
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
