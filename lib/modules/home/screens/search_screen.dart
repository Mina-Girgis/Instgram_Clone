import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../bloc/home_cubit.dart';
import '../components/components.dart';
class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

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
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: TextFormField(
                  style: TextStyle(
                    color: WHITE,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                      filled: true,
                      fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red) 
                    )

                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
