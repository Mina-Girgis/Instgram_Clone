import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stories/flutter_stories.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../models/user_model.dart';
import '../../bloc/home_cubit.dart';

class AddStoryScreen extends StatelessWidget {
  const AddStoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return SafeArea(
          child: WillPopScope(
            onWillPop: ()async{
              cubit.changeAddStoryIndex(0);
              return true;
            },
            child: Scaffold(
              body: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    // fit: StackFit.loose,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth,
                        height: SizeConfig.screenHeight! * 0.70,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            File(cubit.picsAddresses[cubit.addStoryIndex]),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: SizeConfig.defaultSize!*2,left: SizeConfig.defaultSize!*1),
                        child: InkWell(
                          onTap: (){
                            cubit.changeAddStoryIndex(0);
                            Navigator.pop(context);
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.black12,
                            radius: 22,
                            child:Icon( Icons.arrow_back_ios_new_outlined,color: Colors.white, ),
                          ),
                        ),
                      ),
                    ],
                  ),



                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  Container(
                    height: SizeConfig.screenHeight! * 0.08,
                    child: ListView.separated(
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: cubit.picsAddresses.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          width: 7,
                        );
                      },
                      itemBuilder: (context, index) {
                        return InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            cubit.changeAddStoryIndex(index);
                            // print(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            width: 50,
                            height: SizeConfig.screenHeight! * 0.08,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(
                                File(cubit.picsAddresses[index]),
                                fit: BoxFit.cover,
                                color: (cubit.addStoryIndex == index)
                                    ? Color.fromRGBO(255, 255, 255, 0.4)
                                    : Colors.transparent,
                                colorBlendMode: BlendMode.colorDodge,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.02,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white10,
                          ),
                          // height: SizeConfig.screenHeight! * 0.07,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 15,
                                  backgroundImage: NetworkImage(
                                    cubit.userTmp.imageUrl,
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Your story",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white10,
                          ),
                          // height: SizeConfig.screenHeight! * 0.07,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.green,
                                  radius: 15,
                                  child: Padding(
                                    padding: const EdgeInsets.only(right: 2.0),
                                    child: Icon(
                                      FontAwesomeIcons.solidStar,
                                      size: 15,
                                    ),
                                  ),
                                  // backgroundImage:NetworkImage(cubit.userTmp.imageUrl ,),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  "Close friends",
                                  style: TextStyle(
                                    fontSize: 13.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 22,
                        child:Icon( Icons.arrow_forward_ios_outlined, ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                    ],
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
