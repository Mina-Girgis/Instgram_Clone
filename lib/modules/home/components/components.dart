import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_like_button/insta_like_button.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

import '../../../models/post_model.dart';
import '../../../models/user_model.dart';
import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../screens/profile/update_profile_data_screen.dart';

Widget storyDesignItem({bool ovel = true}) {
  return Container(
    // color: Colors.red,
    child: Column(
      children: [
        SizedBox(
          height: 2.0,
        ),
        profilePicWithOvelCircle(
            padding: 5, radius: 46, size: 83, ovelCircle: ovel),
        SizedBox(
          height: 5.0,
        ),
        Container(
          width: 80,
          child: Center(
            child: Text(
              "mina_girgis",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        )
      ],
    ),
  );
}

Widget circleAvatarDesign({required double radius}) {
  return CircleAvatar(
    backgroundImage: AssetImage('assets/person.jpg'),
    radius: radius,
  );
}

Widget profilePicWithOvelCircle({
  required double radius,
  required double size,
  required bool ovelCircle,
  required double padding,
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
          child: circleAvatarDesign(radius: radius),
        ),
      ),
    ),
  );
}

Widget postDesgin(
    {required UserModel? user,
    required context,
    required HomeCubit cubit,
    required PostModel model}) {
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
          child: InstaLikeButton(
            onChanged: () {},
            image: NetworkImage(model.imageUrl),
            height: 300,
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
                  circleAvatarDesign(radius: 17.0),
                  SizedBox(
                    width: 10.0,
                  ),
                  InkWell(
                    radius: 1.0,
                    splashColor: Colors.transparent,
                    onTap: () {
                      cubit.commentController.clear();
                      commentSection(
                          cubit: cubit,
                          context: context,
                          model: model,
                          function: ()async{
                            await cubit.addComment(
                                time: GlobalCubit.get(context).getCurrentTime(),
                                postId: model.postId,
                                text: cubit.commentController.text,
                                username: CacheHelper.getData(key: 'username').toString(),
                            ).then((value){
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

AppBar appBar({required String title, required context, required Function()? onSave, required HomeCubit cubit}) {
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
          icon: const Icon(
            FontAwesomeIcons.check,
            size: 27.0,
            color: BUTTON_COLOR,
          ),
        ),
      ),
    ],
  );
}

Future<dynamic> commentSection({required context , required cubit,required PostModel model , required  Function() function}){
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
                      const SizedBox(width: 10,),
                      CircleAvatar(
                        backgroundImage: AssetImage(
                          'assets/person.jpg',
                        ),
                        radius: 25.0,
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            controller: cubit.commentController,
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: "Add a comment...",
                                hintStyle: TextStyle(
                                  color: Colors.white54,
                                )
                            ),
                            style: TextStyle(
                              color: WHITE,
                            ),
                          ),
                          height: 50,
                        ),
                      ),
                      SizedBox(width: 10,),
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