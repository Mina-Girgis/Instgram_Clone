import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../shared/components/constants.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: () async {
            cubit.removeBottomNavBarIndexListTop(context: context);
            return true;
          },
          child: SafeArea(
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    cubit.removeBottomNavBarIndexListTop(context: context);
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
                backgroundColor: Colors.transparent,
                title: Text('Notifications'),
              ),
              body: Column(
                children: [
                  InkWell(
                    onTap: (){
                      cubit.changeBottomNavigationBarIndex(idx: 6);
                    },
                    child: Container(
                      height: SizeConfig.screenHeight!*0.1,
                      width: SizeConfig.screenWidth,
                      // color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                             CircleAvatar(
                               backgroundImage: (cubit.userTmp.followRequests.isEmpty)?NetworkImage(BLACK_IMAGE) :NetworkImage(cubit.users[cubit.userTmp.followRequests[0]]!.username),
                               backgroundColor: Colors.black,
                               radius: SizeConfig.screenHeight!*0.034,
                             ),
                             SizedBox(width: 10.0,),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               mainAxisAlignment: MainAxisAlignment.center,
                               children: [
                                 Text("Follow requests",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                 ),
                                 SizedBox(height: 5.0,),
                                 Text("Approve or ignore requests",
                                  style: TextStyle(
                                    color: GREY,
                                  ),
                                 ),
                               ],
                             ),
                          ],
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
