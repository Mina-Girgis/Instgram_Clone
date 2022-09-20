import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/home_screen.dart';
import 'package:pro/modules/home/screens/profile/profile_screen.dart';
import 'package:pro/modules/home/screens/reel_screen.dart';
import 'package:pro/modules/home/screens/search_screen.dart';
import 'package:pro/modules/home/screens/shop_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';

import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';
import '../components/components.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    // UserModel? user = cubit.users['mina_girgis_alfy'];

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return WillPopScope(
          onWillPop: ()async{
            cubit.removeBottomNavBarIndexListTop(context: context);
            print("----------------------------");
            print(cubit.bottomNavigationBarIndex);
            print("----------------------------");
            return false;
          },
          child: Scaffold(
            // bottomNavigationBar: defaulBottomNavBar(context:context ,cubit: cubit),
            // body: cubit.screens[cubit.bottomNavigationBarIndex],
          ),
        );
      },
    );
  }
}
