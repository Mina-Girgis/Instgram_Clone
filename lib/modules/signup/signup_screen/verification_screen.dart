import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/signup/bloc/signup_cubit.dart';
import 'package:pro/shared/components/components.dart';

import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = SignupCubit.get(context);
    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ENTER CONFIRMATION CODE",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize! * 3,
                    ),
                    Text(
                      "Enter the confirmation code we send to",
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (cubit.signinMethodIndex == 1)
                          Text(cubit.emailController.text),
                        if (cubit.signinMethodIndex == 0)
                          Text(cubit.phoneNumber),
                        SizedBox(
                          height: 16.0,
                          child: TextButton(
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.only(left: 5.0),
                              fixedSize: Size.fromHeight(0),
                            ),
                            onPressed: () {
                              cubit.sendOtpEmail(
                                  cubit.emailController.value.text,context);
                            },
                            child: Text("Resend code."),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize! * 3,
                    ),
                    defaultTextField(
                      suffixIcon: IconButton(
                        onPressed: () {
                          cubit.OTPCodeController.text = "";
                        },
                        icon: Icon(
                          FontAwesomeIcons.x,
                          size: 17,
                          color: HINT_TEXT_COLOR,
                        ),
                      ),
                      hintText: "Enter your code",
                      controller: cubit.OTPCodeController,
                      validator: (value) {},
                      onChanged: (value) {},
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize! * 2,
                    ),
                    defaultButton(
                      child: (state is VerifyEmailAndPhoneLoading)
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
                        if (cubit.signinMethodIndex == 0) {
                          cubit.verifyOTPPhoneNumber(
                              cubit.verId, cubit.OTPCodeController.text,context);
                        } else {
                          cubit.verifyEmail(cubit.emailController.text,
                              cubit.OTPCodeController.text,context);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
