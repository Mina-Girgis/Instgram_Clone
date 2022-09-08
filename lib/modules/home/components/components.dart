import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:insta_like_button/insta_like_button.dart';

import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';

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

Widget postDesgin() {
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
              Text("mina_girgis"),
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
            image: AssetImage('assets/postImage.jpg'),
            height: 300,
          ),
        ),
        Row(
          children: [
            IconButton(
                splashRadius: 15.0,
                onPressed: () {},
                icon: Icon(
                  FontAwesomeIcons.heart,
                  color: WHITE,
                )),
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
                "114 likes",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'mina_girgis ',
                  style: TextStyle(color: WHITE, fontWeight: FontWeight.bold),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Good Morning',
                      style: TextStyle(
                          color: Colors.white54, fontWeight: FontWeight.normal
                          // decoration: TextDecoration.underline,
                          // decorationStyle: TextDecorationStyle.wavy,
                          ),
                      // recognizer: _longPressRecognizer,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text(
                "View 1 comment",
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
                  Text(
                    "Add a comment...",
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
  );
}


Widget profileNumbers({required String text , required int number}){
  return  Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text("${number}",style: TextStyle(
        color: WHITE,
        fontWeight: FontWeight.bold,
        fontSize: 17.0
      ),),
      Text(text,
        style: TextStyle(
          color: HINT_TEXT_COLOR,
          fontSize: 15.0
        ),
      ),
    ],
  );
}
