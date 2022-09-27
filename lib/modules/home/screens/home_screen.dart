import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/add%20post/pick_photo_screen.dart';
import 'package:pro/modules/home/screens/story/story_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/services/utils/size_config.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../models/post_model.dart';
import '../../../models/story_model.dart';
import '../../../models/user_model.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper/cache_helper.dart';
import '../components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              cubit.removeBottomNavBarIndexListTop(context: context);
              return true;
            },
            child: SwipeTo(
              onRightSwipe: () {
                cubit.multiPhotos = false;
                cubit.picsAddresses.clear();
                cubit.getImagesPath();
                AppNavigator.customNavigator(context: context,
                    screen: PickImageScreen(
                      postOrProfilePicOrStory: 2, title: 'Add Story',),
                    finish: false);
              },
              child: Scaffold(
                appBar: AppBar(
                  automaticallyImplyLeading: false,
                  toolbarHeight: 60,
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                  title: Row(
                    children: [
                      Image.asset(
                        'assets/instaWhite.png',
                        width: SizeConfig.defaultSize! * 15,
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
                      onPressed: () {
                        cubit.multiPhotos = false;
                        cubit.picsAddresses.clear();
                        cubit.getImagesPath();
                        AppNavigator.customNavigator(
                            context: context,
                            screen: PickImageScreen(
                              postOrProfilePicOrStory: 0, title: 'New Post',),
                            finish: false);
                      },
                      icon: Icon(
                        Icons.add_box_outlined,
                      ),
                    ),
                    IconButton(
                      iconSize: 30.0,
                      splashRadius: 15,
                      onPressed: () async {
                        cubit.changeBottomNavigationBarIndex(idx: 5);
                        print(cubit.bottomNavigationBarIndex);
                      },
                      icon: Icon(
                        Icons.favorite_border,
                      ),
                    ),
                    Transform.rotate(
                        angle: 50,
                        child: IconButton(
                            iconSize: 30.0,
                            splashRadius: 15,
                            onPressed: () {

                            },
                            icon: Icon(
                              Icons.send_outlined,
                            ))),
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () async {
                    await cubit.getAllPosts();
                    await cubit.getAllUsers();
                  },
                  child: Stack(
                    children: [
                      SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Container(
                          width: SizeConfig.screenWidth,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children:[
                              Container(
                                // color: Colors.grey,
                                height: 130.0,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(left: 0.0, right: 8.0),
                                  child: Container(
                                    width: SizeConfig.screenWidth,
                                    child: Row(
                                      children: [
                                        if(cubit.userTmp.stories.isEmpty)
                                           emptyStoryGesign(radius: 40),
                                        SizedBox(width: 10,),
                                        ListView.separated(
                                          shrinkWrap: true,
                                          physics: ScrollPhysics(),
                                          scrollDirection: Axis.horizontal,
                                          itemCount: cubit.activeStories.length,
                                          separatorBuilder: (context, index) {
                                            return SizedBox(
                                              width: 15.0,
                                            );
                                          },
                                          itemBuilder: (context, index) {
                                            return storyDesignItem(cubit: cubit, context: context, storyList: cubit.activeStories[index]);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              if (cubit.allPosts.isNotEmpty)
                                ListView.separated(
                                  shrinkWrap: true,
                                  physics: ScrollPhysics(),
                                  itemCount: cubit.allPosts.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 10.0,
                                    );
                                  },
                                  itemBuilder: (context, index) {
                                    String username = cubit.allPosts[index]
                                        .username;
                                    return postDesgin(
                                        index: index,
                                        user: cubit.users[username],
                                        context: context,
                                        model: cubit.allPosts[index],
                                        cubit: cubit);
                                  },
                                )
                              else
                                Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: CircularProgressIndicator(),
                                ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
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

Widget emptyStoryItem(){
  return Container();
}
