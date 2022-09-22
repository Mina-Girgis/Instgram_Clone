import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/login/screens/login_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

class SideBarScreen extends StatelessWidget {
  const SideBarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cunit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      CacheHelper.putData(key: 'username', value: '-1').then((
                          value) {
                        Future.delayed(const Duration(milliseconds: 1000), () {
                          cunit.whenLogOut();
                          AppNavigator.customNavigator(context: context,
                              screen: LoginScreen(),
                              finish: true);
                        });
                      });
                    },
                    child: Text("Log out"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
