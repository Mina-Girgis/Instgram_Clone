import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/utils/size_config.dart';
import '../bloc/home_cubit.dart';
import '../components/components.dart';
class ReelScreen extends StatelessWidget {
  const ReelScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: ()async{
              cubit.removeBottomNavBarIndexListTop(context: context);
              return true;
            },
            child: Scaffold(
              bottomNavigationBar: defaulBottomNavBar(context: context,cubit: cubit),

            ),
          );
        },
      ),
    );
  }
}
