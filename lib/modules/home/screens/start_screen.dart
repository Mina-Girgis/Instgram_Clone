import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/home_screen.dart';
import 'package:pro/modules/home/screens/profile/profile_screen.dart';
import 'package:pro/modules/home/screens/reel_screen.dart';
import 'package:pro/modules/home/screens/search_screen.dart';
import 'package:pro/modules/home/screens/shop_screen.dart';

import '../../../shared/components/constants.dart';
import '../components/components.dart';

class StartScreen extends StatelessWidget {
  StartScreen({Key? key}) : super(key: key);
  List<Widget>screens=[
    HomeScreen(),
    SearchScreen(),
    ReelScreen(),
    ShopScreen(),
    ProfileScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            elevation: 0.0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedIconTheme: IconThemeData(
                size: 30.0
            ),
            unselectedIconTheme: IconThemeData(
                size: 30.0
            ),
            currentIndex: cubit.bottomNavigationBarIndex,
            unselectedItemColor: WHITE,
            selectedItemColor: WHITE,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.black,
            onTap: (index) {
              cubit.changeBottomNavigationBarIndex(index);
            },
            items: [
              BottomNavigationBarItem(

                  icon: Icon(
                    Icons.home_filled,
                  ),
                  label: "",
                  backgroundColor: Colors.transparent),
              BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.magnifyingGlass,size: 25.0,),
                label: "item",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.slideshow,),
                label: "item",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_mall,),
                label: "item",
              ),
              BottomNavigationBarItem(
                icon: circleAvatarDesign(radius: 16),
                label: "item",
              ),
            ],
          ),
          body: screens[cubit.bottomNavigationBarIndex],
        );
      },
    );
  }
}
