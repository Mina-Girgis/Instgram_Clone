import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../models/user_model.dart';
import '../../bloc/home_cubit.dart';

class StoryScreen extends StatelessWidget {
  const StoryScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
  listener: (context, state) {
    // TODO: implement listener
  },
  builder: (context, state) {
    return Scaffold(
      body: StoryItem(context: context,user: cubit.userTmp),
    );
  },
);
  }
}

Widget StoryItem({required context , required UserModel user ,}){
  return CupertinoPageScaffold(
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
            color: Colors.red,
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
        width: 90.0,
        height: 90.0,
        padding: const EdgeInsets.all(2.0),
        child: GestureDetector(
          onTap: () {
            showCupertinoDialog(
              context: context,
              builder: (context) {
                return CupertinoPageScaffold(

                  child: Stack(
                    children: [
                      Story(
                        onFlashForward: Navigator.of(context).pop,
                        onFlashBack: Navigator.of(context).pop,
                        momentCount: 5,
                        momentDurationGetter: (idx) => Duration(seconds: 5),
                        momentBuilder: (context, idx) => Image.asset(
                          'assets/person.jpg',
                          fit: BoxFit.contain,
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Card(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                Spacer(),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.topCenter,
                        child: Card(
                          color: Colors.transparent,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                Spacer(),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
                                IconButton(onPressed: (){print(-1);}, icon: Icon(FontAwesomeIcons.circle,color: Colors.white,),),
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
          },
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(user.imageUrl),fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(100.0),
              // color: CupertinoColors.activeBlue,
            ),
          ),
        ),
      ),
    ),
  );
}