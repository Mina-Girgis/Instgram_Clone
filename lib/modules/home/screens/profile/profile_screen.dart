import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/components/components.dart';
import 'package:pro/shared/components/constants.dart';

import '../../../../services/utils/size_config.dart';
import '../../components/components.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            title: Row(
              children: [
                Icon(
                  FontAwesomeIcons.lock,
                  size: 20.0,
                ),
                SizedBox(
                  width: 8.0,
                ),
                Container(
                  width: SizeConfig.screenWidth!/2.5,
                  child: Text(
                    GlobalCubit.get(context).currentUser.username,
                    style: TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ButtonTheme(
                  child: IconButton(
                    splashRadius: 15,
                    iconSize: 30.0,
                    alignment: Alignment.centerLeft,
                    onPressed: () {},
                    icon: Icon(
                      IconData(
                        0xf13d,
                        fontFamily: 'MaterialIcons',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: [
              IconButton(
                iconSize: 30.0,
                splashRadius: 15,
                onPressed: () {},
                icon: Icon(
                  Icons.add_box_outlined,
                ),
              ),
              IconButton(
                iconSize: 30.0,
                splashRadius: 15,
                onPressed: () {},
                icon: Icon(
                  Icons.menu,
                  size: 35.0,
                ),
              ),
              SizedBox(width: 5,),
            ],
          ),
          body: LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0,right: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                profilePicWithOvelCircle(
                                  radius: 50.0,
                                  size: SizeConfig.defaultSize! * 11,
                                  ovelCircle: true,
                                  padding: 0,
                                ),
                                profileNumbers(text: 'Posts', number: 5),
                                profileNumbers(text: 'Followers', number: 307),
                                profileNumbers(text: 'Following', number: 639),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(GlobalCubit.get(context).currentUser.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(GlobalCubit.get(context).currentUser.bio),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: defaultButton(
                                    child: Text(
                                      "Edit profile",
                                      style: TextStyle(
                                        color: WHITE,
                                      ),
                                    ),
                                    color: Color.fromRGBO(30, 30, 30, 1.0),
                                    function: () {
                                      cubit.changeNameController(GlobalCubit.get(context).currentUser.name);
                                      cubit.changeUsernameController(GlobalCubit.get(context).currentUser.username);
                                      cubit.changeBioController(GlobalCubit.get(context).currentUser.bio);
                                      AppNavigator.customNavigator(context: context, screen: EditProfileScreen(), finish: false);
                                    },
                                    height: 4,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  width: 40.0,
                                  height: SizeConfig.defaultSize! * 4,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(30, 30, 30, 1.0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                      splashRadius: 25.0,
                                      onPressed: () {},
                                      icon: Icon(
                                        FontAwesomeIcons.user,
                                        color: WHITE,
                                        size: 20.0,
                                      )),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              // color: Colors.grey,
                              height: 130.0,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 10,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      width: 15.0,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    return storyDesignItem(ovel: false);
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),


                      DefaultTabController(
                        length: 2,
                        child: SizedBox(
                          height: 50,
                          child: AppBar(
                            backgroundColor: Colors.transparent,

                            bottom: TabBar(
                              indicatorColor: WHITE,
                              onTap: (index) {
                                print(index);
                              },
                              physics: ScrollPhysics(),
                              isScrollable: false,
                              tabs: [
                                Tab(
                                  icon: Icon(Icons.directions_bike),
                                ),
                                Tab(
                                  icon: Icon(
                                    Icons.directions_car,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 5,),
                      GridView.count(
                        shrinkWrap: true,
                        physics: ScrollPhysics(),
                        crossAxisCount: 3,
                        mainAxisSpacing: 4.0,
                        crossAxisSpacing: 5.0,
                        children: List.generate(10, (index){
                          return Container(
                            width: SizeConfig.screenWidth!/3,
                            height: 100,
                            color: Colors.grey,
                            child: Image.asset('assets/postImage.jpg',
                              fit: BoxFit.cover,
                            ),
                          );
                        }),
                      ),
                    ]),
              );
            },
          ),
        ));
  },
);
  }
}

