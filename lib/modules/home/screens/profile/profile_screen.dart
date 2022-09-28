import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/profile/side_bar/side_bar_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/components/components.dart';
import 'package:pro/shared/components/constants.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

import '../../../../models/user_model.dart';
import '../../../../services/utils/size_config.dart';
import '../../components/components.dart';
import 'edit_profile_screen.dart';

class ProfileScreen extends StatefulWidget {
  bool fromSearch;

  ProfileScreen({Key? key, required this.fromSearch}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    UserModel user = cubit.userTmp;
    List<Widget>profileRow = [
      // edit profile
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
              color:
              Color.fromRGBO(30, 30, 30, 1.0),
              function: () async {
                cubit.albumNameIndex = -1;
                cubit.changeUserProfileImageTemp(cubit.userTmp.imageUrl);
                cubit.changeNameController(cubit.userTmp.name);
                cubit.changeUsernameController(cubit.userTmp.username);
                cubit.changeBioController(cubit.userTmp.bio);
                AppNavigator.customNavigator(context: context,
                    screen: EditProfileScreen(),
                    finish: false);
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
              color:
              Color.fromRGBO(30, 30, 30, 1.0),
              borderRadius:
              BorderRadius.circular(10),
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
      //follow
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                String currentUsername = CacheHelper.getData(key: 'username')
                    .toString();
                cubit.addToFollowRequests(
                    currentUserName: currentUsername, user: user.username)
                    .then((value) {
                  setState(() {
                    print("Added request success");
                    cubit.getAllUsers(cahngeUserTmp: false);
                    cubit.profileRowIndex = 2;
                  });
                });
              },
              child: Text("Follow"),
              style:
              ElevatedButton.styleFrom(
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      6.0),
                ),
              ),
            ),
          ),
        ],
      ),
      // Requested
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  String currentUsername = CacheHelper.getData(key: 'username')
                      .toString();
                  cubit.removeFromFollowRequests(
                      currentUserName: currentUsername, user: user.username)
                      .then((value) {
                    cubit.getAllUsers(cahngeUserTmp: false);
                    cubit.profileRowIndex = 1;
                  })
                      .catchError((error) {});
                });
              },
              child: Text("Requested"),
              style:
              ElevatedButton.styleFrom(
                primary: HINT_TEXT_COLOR,
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      6.0),
                ),
              ),
            ),
          ),
        ],
      ),

      //Following
      Row(children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Following"),
            style:
            ElevatedButton.styleFrom(
              primary: Colors.white24,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    6.0),
              ),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Expanded(
          child: ElevatedButton(
            onPressed: () {},
            child: Text("Message"),
            style:
            ElevatedButton.styleFrom(
              primary: Colors.white24,
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(
                    6.0),
              ),
            ),
          ),
        ),
        SizedBox(width: 10,),
        Container(
          width: 40.0,
          height: SizeConfig.defaultSize! * 4,
          decoration: BoxDecoration(
            color:
            Color.fromRGBO(30, 30, 30, 1.0),
            borderRadius:
            BorderRadius.circular(10),
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

      //follow back
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                String currentUsername = CacheHelper.getData(key: 'username')
                    .toString();
                cubit.addToFollowRequests(
                    currentUserName: currentUsername, user: user.username)
                    .then((value) {
                  setState(() {
                    print("Added request success");
                    cubit.getAllUsers(cahngeUserTmp: false);
                    cubit.profileRowIndex = 2;
                  });
                });
              },
              child: Text("Follow back"),
              style:
              ElevatedButton.styleFrom(
                shape:
                RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(
                      6.0),
                ),
              ),
            ),
          ),
        ],
      ),
    ];


    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
            child: WillPopScope(
              onWillPop: () async {
                if (widget.fromSearch) {
                  // from search
                  cubit.setUserTmpAsCurrentUserAgain();
                } else {
                  // from profile
                  print("pop page");
                  cubit.removeBottomNavBarIndexListTop(context: context);
                }

                return true;
              },
              child: Scaffold(
                // bottomNavigationBar: defaulBottomNavBar(context: context,cubit: cubit),
                appBar: AppBar(
                  automaticallyImplyLeading: false,
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
                        constraints: BoxConstraints(
                          minWidth: 0.0,
                          maxWidth: SizeConfig.screenWidth! / 2.5,
                        ),
                        child: Text(
                          user.username,
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
                      onPressed: () {
                        AppNavigator.customNavigator(
                            context: context,
                            screen: SideBarScreen(),
                            finish: false);
                      },
                      icon: Icon(
                        Icons.menu,
                        size: 35.0,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    if (widget.fromSearch) {
                      await cubit.getAllUsers(cahngeUserTmp: false);
                    } else {
                      setState(() {});
                      await cubit.getAllUsers();
                    }
                  },
                  child: Stack(
                    children: [
                      LayoutBuilder(
                        builder: (context, constraint) {
                          return SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment
                                          .start,
                                      children: [
                                        SizedBox(height: 15,),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            storyItem(
                                              storyList: cubit.userTmp.stories,
                                              context: context,
                                              username: cubit.userTmp.username,
                                              width: SizeConfig.screenWidth!*0.27,
                                              height: SizeConfig.screenWidth!*0.27,
                                              cubit: cubit,
                                              index: 0,
                                            ),
                                            profileNumbers(
                                                text: 'Posts',
                                                number: user.posts.length),
                                            profileNumbers(
                                                text: 'Followers',
                                                number: user.followers.length),
                                            profileNumbers(
                                                text: 'Following',
                                                number: user.following.length),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          user.name,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        if(cubit.profileRowIndex == 0 ||
                                            cubit.profileRowIndex == 3)
                                          Text(user.bio),
                                        SizedBox(
                                          height: 10,
                                        ),

                                        profileRow[cubit.profileRowIndex],
                                        SizedBox(
                                          height: 10,
                                        ),
                                        // if(cubit.profileRowIndex==0 ||cubit.profileRowIndex==3)
                                        // Container(
                                        //   // color: Colors.grey,
                                        //   height: 130.0,
                                        //   child: Padding(
                                        //     padding: const EdgeInsets.only(
                                        //         left: 0.0, right: 0.0),
                                        //     child: ListView.separated(
                                        //       scrollDirection: Axis.horizontal,
                                        //       itemCount: 10,
                                        //       separatorBuilder: (context, index) {
                                        //         return SizedBox(
                                        //           width: 15.0,
                                        //         );
                                        //       },
                                        //       itemBuilder: (context, index) {
                                        //         return storyDesignItem(ovel: false,cubit: cubit,context: context,storyList: []);
                                        //       },
                                        //     ),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                  if(cubit.profileRowIndex == 0 ||
                                      cubit.profileRowIndex == 3)
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
                                                icon: Icon(
                                                  Icons.grid_on_outlined,
                                                  size: 25.0,),
                                              ),
                                              Tab(
                                                icon: Icon(IconData(0xee34,
                                                    fontFamily: 'MaterialIcons'),
                                                  size: 25.0,),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  if(cubit.profileRowIndex == 0 ||
                                      cubit.profileRowIndex == 3)
                                    SizedBox(
                                      height: 5,
                                    ),
                                  if(cubit.profileRowIndex == 0 ||
                                      cubit.profileRowIndex == 3)
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics: ScrollPhysics(),
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 3.0,
                                      crossAxisSpacing: 3.0,
                                      children:
                                      List.generate(user.posts.length, (index) {
                                        return Container(
                                          width: SizeConfig.screenWidth! / 3,
                                          height: 100,
                                          color: Colors.grey,
                                          child: Image.network(
                                            user.posts[index].imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                        );
                                      }),
                                    ),

                                  if(cubit.profileRowIndex != 0 &&
                                      cubit.profileRowIndex != 3)
                                    Column(
                                      children: [
                                        Divider(thickness: 0, color: GREY,),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10.0, right: 10),
                                          child: Row(
                                            children: [

                                              CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    'assets/lock.jpg'),
                                                backgroundColor: Colors
                                                    .transparent,
                                                radius: 32.0,
                                              ),
                                              SizedBox(width: 20.0,),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment
                                                    .start,
                                                children: [
                                                  Text(
                                                      "This Account Is Private"),
                                                  SizedBox(height: 3.0,),
                                                  Text(
                                                    "Follow this account to see their photos",
                                                    style: TextStyle(
                                                      color: GREY,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ]),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
