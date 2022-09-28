import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_like_button/insta_like_button.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';
import 'package:swipe_to/swipe_to.dart';

import '../../../models/post_model.dart';
import '../../../models/story_model.dart';
import '../../../models/user_model.dart';
import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../screens/profile/update_profile_data_screen.dart';
import '../screens/story/story_screen.dart';

Widget storyDesignItem({
  required context,
  required HomeCubit cubit,
  required List<StoryModel> storyList,
  required int index,
  bool ovel = true,
}) {
  return Container(
    // color: Colors.red,
    child: Column(
      children: [
        SizedBox(
          height: 2.0,
        ),
        //***//
        StoryItem(
          context: context,
          username: storyList[0].username,
          width: 80,
          height: 80,
          storyList: storyList,
          cubit: cubit,
          ovel: ovel,
          index:index,
        ),
        //***//
        SizedBox(
          height: 5.0,
        ),
        Container(
          width: 80,
          child: Center(
            child: Text(
              storyList[0].username,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    ),
  );
}

Widget emptyStoryGesign({required double radius, required HomeCubit cubit}) {
  return Container(
    // color: Colors.red,
    child: Column(
      children: [
        SizedBox(
          height: 2.0,
        ),
        //***//
        Stack(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(cubit.userTmp.imageUrl),
              backgroundColor: Colors.white,
              radius: radius,
            ),
            Padding(
              padding:  EdgeInsets.only(left: radius*1.5,top: radius*1.4),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(FontAwesomeIcons.add,color: Colors.white,size: 17,),
              ),
            ),
          ],
        ),

        //***//
        SizedBox(
          height: 5.0,
        ),
        Container(
          width: 80,
          child: Center(
            child: Text(
              'Add story',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    ),
  );
}

Widget StoryItem({
  required List<StoryModel> storyList,
  required context,
  required String username,
  required double width,
  required double height,
  required HomeCubit cubit,
  required bool ovel,
  required int index,
}) {
  String CurrentUsername=CacheHelper.getData(key: 'username').toString();
  return CupertinoPageScaffold(
      child: Center(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100.0),
        border: Border.all(
          color: (cubit.allSeen(storyList)) ? Colors.grey : Colors.red,
          width: 2.0,
          style: BorderStyle.solid,
        ),
      ),
      width: width,
      height: height,
      padding: const EdgeInsets.all(2.0),
      child: GestureDetector(
        onTap: () {
          if (!ovel) {
            print("-1");
          } else {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoPageScaffold(
                  child: Stack(
                    children: [
                      Story(
                        onFlashForward: Navigator.of(context).pop,
                        onFlashBack: Navigator.of(context).pop,
                        momentCount: storyList.length,
                        momentDurationGetter: (idx) => Duration(seconds: 5),
                        momentBuilder: (context, idx) {
                          cubit.addToStoriesSeen(username: cubit.userTmp.username, storyId: storyList[idx].storyId);
                          cubit.seeSpecificStory(storyOwner: storyList[idx].username, storyId: storyList[idx].storyId);
                          cubit.storiesSeen[storyList[idx].storyId] = true;
                          cubit.changeCurrentStoryIndex(idx);
                          return Image.network(storyList[idx].imageUrl, fit: BoxFit.contain,);
                        },
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0,left: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 20.0,
                                  backgroundImage: NetworkImage(cubit.users[username]!.imageUrl),
                                  backgroundColor: Colors.black,
                                ),
                                SizedBox(width: 7,),
                                Text(username),
                                IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    FontAwesomeIcons.circle,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if(username!=CacheHelper.getData(key: 'username').toString())
                         Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    cubit.addLikeToSpecificStory(username: CurrentUsername, storyOwnerUsername: username, storyId: storyList[cubit.currentStoryIndex].storyId);
                                    // cubit.addToStoriesILiked(storyList[cubit.currentStoryIndex].storyId);
                                   },
                                  icon: Icon(
                                    FontAwesomeIcons.heart,
                                    color: (cubit.storiesILiked[storyList[cubit.currentStoryIndex].storyId]==true)?Colors.red :Colors.white,
                                    size: 30.0,
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
                                          color: Colors.white,
                                        ))),
                              ],
                            ),
                          ),
                        ),
                      ),

                      if(username==CacheHelper.getData(key: 'username').toString())
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 20.0,left: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  InkWell(
                                    onTap: (){},
                                    borderRadius: BorderRadius.circular(20),
                                    child: Stack(
                                      children: [

                                        if(storyList[cubit.currentStoryIndex].views.length >= 3)
                                        Padding(
                                          padding: const EdgeInsets.only(left:30),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(cubit.users[storyList[cubit.currentStoryIndex].views[2]]!.imageUrl),
                                          ),
                                        ),

                                        if(storyList[cubit.currentStoryIndex].views.length >= 2)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 15),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(cubit.users[storyList[cubit.currentStoryIndex].views[1]]!.imageUrl),
                                          ),
                                        ),

                                        if(storyList[cubit.currentStoryIndex].views.length >= 1)
                                        Padding(
                                          padding: const EdgeInsets.only(left: 0),
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundImage: NetworkImage(cubit.users[storyList[cubit.currentStoryIndex].views[0]]!.imageUrl),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                    ],
                  ),
                );
              },
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: (cubit.users[username] == null)
                  ? NetworkImage(BLACK_IMAGE)
                  : NetworkImage(cubit.users[username]!.imageUrl),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(100.0),
          ),
        ),
      ),
    ),
  ));
}

Widget circleAvatarDesign(
    {required HomeCubit cubit, required double radius, String imageUrl = ""}) {
  return CircleAvatar(
    backgroundImage: picImage(imageUrl, cubit),
    radius: radius,
  );
}

ImageProvider picImage(String image, HomeCubit cubit) {
  if (cubit.userTmp.imageUrl == image)
    return NetworkImage(image);
  else if (image == "")
    return NetworkImage(
        'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8cGVyc29ufGVufDB8fDB8fA%3D%3D&w=1000&q=80');
  else
    return FileImage(File(image));
}

Widget profilePicWithOvelCircle({
  required double radius,
  required double size,
  required bool ovelCircle,
  required double padding,
  required cubit,
}) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: (ovelCircle)
            ? AssetImage(
                'assets/instaOvel2.jpg',
              )
            : AssetImage(
                'assets/black.jpg',
              ),
      ),
      borderRadius: BorderRadius.circular(100.0),
    ),
    child: Container(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Center(
          child: circleAvatarDesign(radius: radius, cubit: cubit),
        ),
      ),
    ),
  );
}

Widget postDesgin(
    {required UserModel? user,
    required index,
    required context,
    required HomeCubit cubit,
    required PostModel model}) {
  CarouselController buttonCarouselController = CarouselController();
  return Container(
    width: SizeConfig.screenWidth,
    // color: Colors.grey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Row(
            children: [
              profilePicWithOvelCircle(
                cubit: cubit,
                size: 45,
                radius: 60,
                ovelCircle: true,
                padding: 3,
              ),
              SizedBox(
                width: 10.0,
              ),
              Container(
                constraints: BoxConstraints(
                  maxWidth: SizeConfig.screenWidth! / 2,
                  minWidth: 10,
                ),
                child: Text(
                  user!.username,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                width: 5.0,
              ),
              Icon(
                IconData(
                  0xe699,
                  fontFamily: 'MaterialIcons',
                ),
                color: Colors.blue,
                size: 15.0,
              ),
              Spacer(),
              IconButton(
                splashRadius: 15.0,
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  color: WHITE,
                  size: 26,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8.0,
        ),
        Container(
          // color: Colors.blue,
          width: SizeConfig.screenWidth,
          child: ImageSlideshow(
            height: 320,
            children: model.photos.map((e) {
              return InstaLikeButton(
                onChanged: () {
                  if (!model.isLiked) {
                    String username =
                        CacheHelper.getData(key: 'username').toString();
                    cubit.likePost(postId: model.postId, username: username);
                    cubit.changeLikeStateInAllPosts(postId: model.postId);
                  }
                },
                image: NetworkImage(e),
                height: 320,
              );
            }).toList(),
            // isLoop: true,
            indicatorColor:
                (model.photos.length == 1) ? Colors.transparent : Colors.white,
            indicatorBackgroundColor:
                (model.photos.length == 1) ? Colors.transparent : Colors.grey,
          ),
        ),
        Row(
          children: [
            IconButton(
              splashRadius: 15.0,
              onPressed: () {
                String username =
                    CacheHelper.getData(key: 'username').toString();
                if (model.isLiked)
                  cubit.unlikePost(postId: model.postId, username: username);
                else
                  cubit.likePost(postId: model.postId, username: username);
                cubit.changeLikeStateInAllPosts(postId: model.postId);
              },
              icon: Icon(
                FontAwesomeIcons.heart,
                color: (model.isLiked == true) ? Colors.red : Colors.white,
              ),
            ),
            IconButton(
                splashRadius: 15.0,
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.comment,
                  color: WHITE,
                )),
            Transform.rotate(
                angle: 50,
                child: IconButton(
                    color: WHITE,
                    iconSize: 30.0,
                    splashRadius: 15,
                    onPressed: () {},
                    icon: Icon(
                      Icons.send_outlined,
                    ))),
            Spacer(),
            IconButton(
              splashRadius: 15.0,
              onPressed: () {},
              icon: Icon(
                Icons.bookmark_border,
                color: WHITE,
                size: 35,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 0.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${model.likes.length} likes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: user.username + "  ",
                  style: TextStyle(color: WHITE, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: model.description,
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.normal),
                      // recognizer: _longPressRecognizer,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "View ${model.comments.length} comments",
                style: TextStyle(
                  color: GREY,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  circleAvatarDesign(radius: 17.0, cubit: cubit),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    radius: 1.0,
                    splashColor: Colors.transparent,
                    onTap: () {
                      cubit.commentController.clear();
                      String username =
                          CacheHelper.getData(key: 'username').toString();
                      commentSection(
                        cubit: cubit,
                        context: context,
                        model: model,
                        function: () async {
                          await cubit
                              .addComment(
                            time: GlobalCubit.get(context).getCurrentTime(),
                            postId: model.postId,
                            text: cubit.commentController.text,
                            username: username,
                          )
                              .then((value) {
                            cubit.allPosts[index].comments.add(CommentModel(
                                time: GlobalCubit.get(context).getCurrentTime(),
                                username: username,
                                text: cubit.commentController.text));
                            Navigator.pop(context);
                          });
                        },
                      );
                    },
                    child: Text(
                      "Add a comment...",
                      style: TextStyle(
                        color: GREY,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget profileNumbers({required String text, required int number}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        "${number}",
        style: TextStyle(
            color: WHITE, fontWeight: FontWeight.bold, fontSize: 17.0),
      ),
      Text(
        text,
        style: TextStyle(color: HINT_TEXT_COLOR, fontSize: 15.0),
      ),
    ],
  );
}

Widget editProfileInputField({
  required String label,
  // String initialValue="",
  required index,
  required context,
  required controller,
  required Function(String value) onChange,
  required Function ontab,
  bool readOnly = true,
}) {
  return TextFormField(
    controller: controller,
    onChanged: onChange,
    onTap: () {
      if (readOnly) {
        ontab();
      }
    },
    autofocus: !readOnly,
    readOnly: readOnly,
    // initialValue: initialValue,
    style: TextStyle(
      color: WHITE,
    ),
    decoration: InputDecoration(
      label: Text(
        label,
        style: TextStyle(
          color: Colors.white54,
        ),
      ),
      labelStyle: TextStyle(height: 0.3),
      filled: true,
      fillColor: Colors.black,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: GREY, width: 3.0),
      ),
      border: const UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.transparent),
      ),
    ),
  );
}

AppBar appBar(
    {required String title,
    required context,
    required Function()? onSave,
    required HomeCubit cubit}) {
  return AppBar(
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    automaticallyImplyLeading: false,
    title: Text(title),
    leading: InkWell(
        onTap: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        child: const Icon(FontAwesomeIcons.x)),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: 0.0),
        child: IconButton(
          onPressed: onSave,
          icon: Icon(
            FontAwesomeIcons.check,
            size: 27.0,
            color: BUTTON_COLOR,
          ),
        ),
      ),
    ],
  );
}

Future<dynamic> commentSection(
    {required context,
    required cubit,
    required PostModel model,
    required Function() function}) {
  return showModalBottomSheet(
      elevation: 0.0,
      backgroundColor: Colors.black,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: AnimatedPadding(
            duration: const Duration(milliseconds: 100),
            padding: MediaQuery.of(context).viewInsets,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/person.jpg',
                        ),
                        radius: 25.0,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            controller: cubit.commentController,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "Add a comment...",
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                )),
                            style: TextStyle(
                              color: WHITE,
                            ),
                          ),
                          height: 50,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      TextButton(
                        onPressed: function,
                        child: Text("post"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      });
}

Widget defaulBottomNavBar({required context, required HomeCubit cubit}) {
  return BottomNavigationBar(
    elevation: 0.0,
    showSelectedLabels: false,
    showUnselectedLabels: false,
    selectedIconTheme: IconThemeData(size: 30.0),
    unselectedIconTheme: IconThemeData(size: 30.0),
    currentIndex: (cubit.bottomNavigationBarIndex > 4)
        ? 0
        : cubit.bottomNavigationBarIndex,
    unselectedItemColor: WHITE,
    selectedItemColor: WHITE,
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    onTap: (index) {
      if (cubit.bottomNavigationBarIndex != index) {
        // AppNavigator.customNavigator(context: context, screen: cubit.screens[index], finish: false);
        cubit.changeBottomNavigationBarIndex(idx: index);
        print(cubit.bottomNavigationBarIndex);
      }
    },
    items: [
      BottomNavigationBarItem(
          icon: Icon(
            Icons.home_filled,
          ),
          label: "",
          backgroundColor: Colors.transparent),
      BottomNavigationBarItem(
        icon: Icon(
          FontAwesomeIcons.magnifyingGlass,
          size: 25.0,
        ),
        label: "item",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.slideshow,
        ),
        label: "item",
      ),
      BottomNavigationBarItem(
        icon: Icon(
          Icons.local_mall,
        ),
        label: "item",
      ),
      BottomNavigationBarItem(
        icon: circleAvatarDesign(radius: 16, cubit: cubit),
        label: "item",
      ),
    ],
  );
}
