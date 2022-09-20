import 'package:flutter/material.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/login/screens/login_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';
class SideBarScreen extends StatelessWidget {
  const SideBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextButton(
                  onPressed: (){
                    CacheHelper.putData(key: 'username', value: '-1').then((value){
                      HomeCubit.get(context).changeBottomNavigationBarIndex(idx: 0);
                      HomeCubit.get(context).bottomNavBarIndexList.clear();
                      AppNavigator.customNavigator(context: context, screen: LoginScreen(), finish: true);
                    });

                  },
                  child: Text("Log out"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
