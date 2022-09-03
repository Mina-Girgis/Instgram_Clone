import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:pro/modules/login_screen/login_screen.dart';
import '../modules/splach_screen/splach_screen.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: Colors.white,
          ),
        )
      ),
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}

/*MultiBlocProvider(
      providers: [
        // BlocProvider(create: (BuildContext context) => BlocCubit(),),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: LoginScreen(),
      ),
    );*/