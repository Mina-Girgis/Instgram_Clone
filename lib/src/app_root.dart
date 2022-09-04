import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pro/modules/login_screen/login_screen.dart';
import '../modules/signup/bloc/signin_cubit.dart';
import '../modules/signup/signup_screen/signup_screen.dart';
import '../modules/splach_screen/splach_screen.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => SigninCubit(),),

      ],
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.white,
              ),
            )
        ),
        debugShowCheckedModeBanner: false,
        home: SignupScreen(),
      ),
    );;
  }
}
