import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/home_screen.dart';
import 'package:pro/modules/home/screens/start_screen.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';
import '../global_bloc/global_cubit.dart';
import '../modules/home/screens/pick_photo_screen.dart';
import '../modules/login/bloc/login_cubit.dart';
import '../modules/login/screens/login_screen.dart';
import '../modules/signup/bloc/signup_cubit.dart';
import '../modules/signup/signup_screen/signup_info_screen.dart';
import '../modules/signup/signup_screen/signup_screen.dart';
import '../modules/signup/signup_screen/verification_screen.dart';
import '../modules/splach_screen/splach_screen.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => GlobalCubit()..getAllUsers()),
        BlocProvider(create: (BuildContext context) => SignupCubit()),
        BlocProvider(create: (BuildContext context) => LoginCubit()),
        BlocProvider(create: (BuildContext context) => HomeCubit()),

      ],
      child: MaterialApp(
        theme: ThemeData(
            scaffoldBackgroundColor: Colors.black,
            textTheme: TextTheme(
              bodyText2: TextStyle(
                color: Colors.white,
              ),
            )),
        debugShowCheckedModeBanner: false,
        home: BlocConsumer<GlobalCubit, GlobalState>(
          listener: (context, state) {},
          builder: (context, state) {
            // return LoginScreen();
            var screen = (CacheHelper.getData(key: 'username') == '-1' ||CacheHelper.getData(key: 'username') == null )?LoginScreen():StartScreen();

            if(screen is LoginScreen)
              return screen;
            else
              {
                print(GlobalCubit.get(context).currentUser.username);
                return (GlobalCubit.get(context).currentUser.username=="")?SplachScreen() : screen;
              }
          },
        ),
      ),
    );
    ;
  }
}
