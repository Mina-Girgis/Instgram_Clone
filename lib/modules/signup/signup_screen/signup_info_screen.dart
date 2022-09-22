import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/modules/signup/bloc/signup_cubit.dart';
import 'package:pro/modules/signup/signup_screen/signup_screen.dart';
import 'package:pro/services/utils/size_config.dart';
import 'package:pro/shared/components/components.dart';

import '../../../shared/components/constants.dart';
import '../../home/bloc/home_cubit.dart';

class SignUpInfoScreen extends StatelessWidget {
  SignUpInfoScreen({Key? key}) : super(key: key);
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {

    SizeConfig.init(context);
    var cubit = SignupCubit.get(context);

    return BlocConsumer<SignupCubit, SignupState>(
      listener: (context, state) {
        if(state is AddNewUserSuccess)
          {
            HomeCubit.get(context).getAllUsers();
            HomeCubit.get(context).allPosts.clear();
            HomeCubit.get(context).getAllPosts();
          }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Container(
                width: SizeConfig.screenWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: SizeConfig.defaultSize! * 8),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "USERNAME AND PASSWORD",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize! * 3,
                        ),
                        defaultTextField(
                          hintText: "Username",
                          controller: cubit.userNameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Username must not be empty";
                            }
                            else if(value.length>15){
                              return "Username must be less than 15 letters";
                            }
                            else
                              return null;
                          },
                          onChanged: (value) {},
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize! * 1.5,
                        ),
                        defaultTextField(
                          obscure: true,
                          hintText: "Password",
                          controller: cubit.passwordController,
                          validator: (value) {
                            if (value!.length < 8) {
                              return "Password must be greater than 8";
                            }
                            return null;
                          },
                          onChanged: (value) {},
                        ),

                        SizedBox(
                          height: SizeConfig.defaultSize! * 1.5,
                        ),
                        Row(
                          children: [
                            Checkbox(
                                checkColor: Colors.black,
                                value: cubit.checkBoxBoolean,
                                onChanged: (value) {
                                  cubit.changeCheckBoxBoolean(value);
                                },
                                fillColor:
                                    MaterialStateProperty.resolveWith((states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.black;
                                  }
                                  return Colors.blue;
                                })),
                            Text(
                              "Remember me",
                              style: TextStyle(
                                color: GREY,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize! * 1.5,
                        ),
                        defaultButton(
                          child: (state is AddNewUserLoading)
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
                          function: () async {
                            if (formKey.currentState!.validate()) {

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(cubit.userNameController.text.toLowerCase())
                                  .get()
                                  .then((value) {
                                if (value.exists) {
                                  toastMessage(
                                    text: "Username is already exists",
                                    backgroundColor: GREY,
                                    textColor: WHITE,
                                  );
                                  cubit.passwordController.text = "";
                                  cubit.userNameController.text = "";
                                  print(value.exists);
                                } else {
                                  cubit.addNewUser(context);
                                }
                              }).catchError((error){
                                print(123);
                              });
                            }
                          },
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
