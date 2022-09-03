import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../shared/components/components.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: SizeConfig.screenHeight! -90,
            ),
            child: IntrinsicHeight(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  Container(
                    height: SizeConfig.screenHeight!*0.14,
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
                              hintText: "Phone number, email or username",
                              controller: emailController),
                          SizedBox(
                            height: SizeConfig.defaultSize! * 1.5,
                          ),
                          defaultTextField(
                              hintText: "Password",
                              controller: passwordController,
                              obscure: true),
                          SizedBox(
                            height: SizeConfig.defaultSize! * 1.5,
                          ),
                          ButtonTheme(
                              minWidth: SizeConfig.screenWidth!,
                              height: SizeConfig.defaultSize! * 5,
                              child: RaisedButton(
                                onPressed: () {},
                                color: Color.fromRGBO(0, 148, 245, 1.0),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )),
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
                            Text("Don't have an account?"),
                            TextButton(
                                onPressed: (){},
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
          );
  }
}

