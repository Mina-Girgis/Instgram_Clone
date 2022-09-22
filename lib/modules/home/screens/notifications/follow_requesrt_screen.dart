import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

import '../../../../services/utils/size_config.dart';
import '../../../../shared/components/constants.dart';

class FollowRequestScreen extends StatelessWidget {
  const FollowRequestScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: ()async{
              cubit.removeBottomNavBarIndexListTop(context: context);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    cubit.removeBottomNavBarIndexListTop(context: context);
                  },
                  icon: Icon(FontAwesomeIcons.arrowLeft),
                ),
                backgroundColor: Colors.transparent,
                title: Text('Follow requests'),
              ),
              body: SingleChildScrollView(
                physics: ScrollPhysics(),
                child: Column(
                  children: [
                    ListView.separated(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        itemCount: cubit.userTmp.followRequests.length,
                        separatorBuilder:(context,index){
                          return SizedBox(height: 20.0,);
                        },
                        itemBuilder: (context,index){
                          // convert map to list
                          List<String> followRequests = [];
                          cubit.userTmp.followRequests.forEach((key, value) {
                            followRequests.add(key);
                          });
                          return Padding(
                            padding: const EdgeInsets.only(left:10.0 ,right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(cubit.users[followRequests[index]]!.imageUrl),
                                  radius: SizeConfig.screenHeight!*0.034,
                                ),
                                SizedBox(width: 10.0,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(

                                      child: Text(
                                        cubit.users[followRequests[index]]!.username,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                            overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                      constraints: BoxConstraints(
                                        maxWidth: SizeConfig.screenWidth!/3,
                                      ),
                                    ),
                                    SizedBox(height: 5.0,),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth: SizeConfig.screenWidth!/3,
                                      ),
                                      child: Text(
                                        cubit.users[followRequests[index]]!.name,
                                        style: TextStyle(
                                          color: GREY,
                                          overflow: TextOverflow.ellipsis
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(),
                                ElevatedButton(
                                    onPressed: ()async{
                                      // addToFollowers
                                      //   addToFollowing
                                      // removeFromMyFollowRequests
                                      String currentUserName = CacheHelper.getData(key: 'username').toString();
                                      String user = cubit.users[followRequests[index]]!.username;
                                      await cubit.addToFollowers(currentUserName: currentUserName, user: user);
                                      await cubit.addToFollowing(currentUserName: currentUserName, user: user);
                                      await cubit.removeFromMyFollowRequests(currentUserName: currentUserName, user: user);
                                      // await cubit.getAllUsers();
                                      },
                                    child: Text("Confirm"),
                                    style: ElevatedButton.styleFrom(
                                    shape:
                                    RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(
                                          6.0),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10.0,),
                                ElevatedButton(
                                  onPressed: ()async{
                                    String currentUserName = CacheHelper.getData(key: 'username').toString();
                                    String user = cubit.users[followRequests[index]]!.username;
                                    await cubit.removeFromMyFollowRequests(currentUserName: currentUserName, user: user);
                                    // await cubit.getAllUsers();
                                  },
                                  child: Text("Delete"),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    primary: Colors.white10,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
