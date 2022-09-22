import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/login/bloc/login_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../signup/signup_screen/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var cubit = LoginCubit.get(context);
    SizeConfig.init(context);
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if(state is validEmailAndPasswordSuccess){
           HomeCubit.get(context).getAllUsers();
           HomeCubit.get(context).allPosts.clear();
           HomeCubit.get(context).getAllPosts();
           print(HomeCubit.get(context).allPosts.length);
        }
      },
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
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Spacer(),
                        Container(
                          height: SizeConfig.screenHeight! * 0.14,
                        ),
                        Container(
                          // height: SizeConfig.screenHeight!*0.7,
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: SizeConfig.defaultSize! * 2,
                                right: SizeConfig.defaultSize! * 2),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/instaWhite.png',
                                  width: SizeConfig.screenWidth! / 1.8,
                                ),
                                SizedBox(
                                  height: SizeConfig.defaultSize! * 3,
                                ),
                                defaultTextField(
                                    onChanged: (String? s) {},
                                    hintText: "Phone number, email or username",
                                    controller: cubit.usernameController,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Enter Valid Email";
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: SizeConfig.defaultSize! * 1.5,
                                ),
                                defaultTextField(
                                    onChanged: (String? s) {},
                                    hintText: "Password",
                                    controller: cubit.passwordController,
                                    obscure: true,
                                    validator: (String? value) {
                                      if (value!.isEmpty) {
                                        return "Enter Valid Email";
                                      }
                                      return null;
                                    }),
                                SizedBox(
                                  height: SizeConfig.defaultSize! * 1.5,
                                ),
                                defaultButton(
                                  child: (state is ValidEmailAndPasswordLoading)
                                      ? CircularProgressIndicator(
                                          color: WHITE,
                                          strokeWidth: 3.0,
                                        )
                                      : Text(
                                          'Log in',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                  function: () {
                                    if (formKey.currentState!.validate()) {
                                      cubit.validEmailAndPassword(email: cubit.usernameController.text, password: cubit.passwordController.text, context: context,);

                                    }
                                  },
                                ),
                                SizedBox(
                                  height: SizeConfig.defaultSize! * 1,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Forgot your login details?",
                                      style: TextStyle(
                                        color: Color.fromRGBO(
                                            129, 128, 128, 0.8235294117647058),
                                      ),
                                    ),
                                    TextButton(
                                        onPressed: () {},
                                        child: Text(
                                          "Get help loggin in.",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )),
                                  ],
                                ),
                                Row(children: [
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.9,
                                  )),
                                  Text(
                                    "  OR  ",
                                    style: TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.9,
                                  )),
                                ]),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.facebook,
                                      color: Colors.blue,
                                      size: 35.0,
                                    ),
                                    TextButton(
                                      onPressed: () {},
                                      child: Text("Log in with Facebook"),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Spacer(),
                        Container(
                          // height: SizeConfig.screenHeight!*0.1,
                          alignment: Alignment.bottomCenter,
                          // color: Colors.red,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Divider(
                                    color: Colors.grey,
                                    thickness: 0.0,
                                  )),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Don't have an account?",
                                    style: TextStyle(
                                      color: GREY,
                                    ),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        AppNavigator.customNavigator(
                                            context: context,
                                            screen: SignupScreen(),
                                            finish: true);
                                      },
                                      child: Text(
                                        "Sign up.",
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
