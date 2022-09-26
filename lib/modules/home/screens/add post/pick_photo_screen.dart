import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../shared/components/constants.dart';
import '../story/story_screen.dart';
import 'add_post_screen.dart';

class PickImageScreen extends StatefulWidget {
  int postOrProfilePicOrStory; // 0 or 1 or 2
  String title;
  PickImageScreen({Key? key, required this.postOrProfilePicOrStory ,required this.title}) : super(key: key);

  @override
  State<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends State<PickImageScreen> {
  late ScrollController _scrollController;
  void onPop(HomeCubit cubit){
    cubit.multiPhotos=false;
    cubit.picsAddresses.clear();
  }
  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController();
    var cubit = HomeCubit.get(context);

    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return WillPopScope(
          onWillPop: ()async{
            onPop(cubit);
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  cubit.imageIndex = -1;
                  cubit.albumNameIndex = -1;
                  onPop(cubit);
                  Navigator.pop(context);
                },
                icon: Icon(FontAwesomeIcons.x),
              ),
              title: Text(widget.title),
              actions: [
                if (cubit.picsAddresses.isNotEmpty)
                  IconButton(
                    onPressed: () {
                      if (widget.postOrProfilePicOrStory == 0) {
                        AppNavigator.customNavigator(context: context, screen: AddPostScreen(), finish: false);
                      } else if(widget.postOrProfilePicOrStory==1) {
                        cubit.changeUserProfileImageTemp(cubit.files[cubit.albumNameIndex].files[cubit.imageIndex]);
                        Navigator.pop(context);
                      }else if(widget.postOrProfilePicOrStory==2){
                        AppNavigator.customNavigator(context: context, screen: AddStoryScreen(), finish: false);
                      }
                    },
                    icon: Icon(FontAwesomeIcons.arrowRight),
                  ),
              ],
            ),
            body: (cubit.albumNameIndex == -1)
                ? Container()
                : CustomScrollView(
                    controller: _scrollController,
                    slivers: <Widget>[
                      SliverAppBar(
                        backgroundColor: Colors.black,
                        automaticallyImplyLeading: false,
                        pinned: true,
                        snap: true,
                        floating: true,
                        expandedHeight: SizeConfig.screenHeight! / 2.0,
                        toolbarHeight: 40.0,
                        flexibleSpace: FlexibleSpaceBar(
                          titlePadding: EdgeInsets.all(0),
                          title: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: SizeConfig.screenWidth! / 2,
                                  ),
                                  // height: 10,
                                  child: Text(
                                    cubit.files[cubit.albumNameIndex].folderName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                IconButton(
                                    color: WHITE,
                                    padding: EdgeInsets.only(left: 0.0),
                                    onPressed: () {
                                      showModalBottomSheet(
                                        backgroundColor: Colors.black,
                                        context: context,
                                        isScrollControlled: true,
                                        isDismissible: true,
                                        enableDrag: true,
                                        builder: (context) {
                                          return SingleChildScrollView(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0),
                                              child: Container(
                                                width:
                                                    SizeConfig.screenWidth! / 1.5,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Container(
                                                          width: SizeConfig
                                                                  .screenWidth! /
                                                              4,
                                                          height: 4.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.0,
                                                    ),
                                                    ListView.separated(
                                                      shrinkWrap: true,
                                                      physics:
                                                          BouncingScrollPhysics(),
                                                      itemCount:
                                                          cubit.files.length,
                                                      separatorBuilder:
                                                          (context, index) {
                                                        return SizedBox(
                                                          height: 10.0,
                                                        );
                                                      },
                                                      itemBuilder:
                                                          (context, index) {
                                                        return InkWell(
                                                          onTap: () {
                                                            print(cubit
                                                                .files[index]
                                                                .folderName);
                                                            cubit
                                                                .changeDropdownButtonHintText(
                                                                    index);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    left: 10.0),
                                                            child: Container(
                                                              width: SizeConfig
                                                                      .screenWidth! /
                                                                  2,
                                                              height: 50,
                                                              child: Text(
                                                                cubit.files[index]
                                                                    .folderName,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
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
                                      );
                                    },
                                    icon: Icon(
                                      IconData(
                                        0xf13d,
                                        fontFamily: 'MaterialIcons',
                                      ),
                                    )),
                                Spacer(),
                                if(widget.postOrProfilePicOrStory!=1)
                                  IconButton(
                                    onPressed: () {
                                      cubit.changeMultiPhotos();
                                    },
                                    icon: Icon(
                                      Icons.grid_on_outlined,
                                      size: 19,
                                      color: (cubit.multiPhotos == true)
                                          ? Colors.blue
                                          : WHITE,
                                    )),
                              ],
                            ),
                          ),
                          background: Image.file(
                            File(cubit.files[cubit.albumNameIndex]
                                .files[cubit.imageIndex]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SliverToBoxAdapter(
                        child: SizedBox(
                          height: 2,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return GridView.count(
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              crossAxisCount: 4,
                              mainAxisSpacing: 2,
                              crossAxisSpacing: 2,
                              children: List.generate(
                                  cubit.files[cubit.albumNameIndex].files.length,
                                  (index) {
                                String pic = cubit
                                    .files[cubit.albumNameIndex].files[index];
                                return Container(
                                  width: SizeConfig.screenWidth! / 4,
                                  height: 100,
                                  color: Colors.grey,
                                  child: InkWell(

                                    onLongPress: (){
                                      if(widget.postOrProfilePicOrStory!=1){
                                        cubit.changeImageIndex(index);
                                        print(index);
                                        String imageAddress = cubit.files[cubit.albumNameIndex].files[index];
                                        cubit.multiPhotos=true;
                                        if (cubit.picsAddresses.contains(imageAddress)) {
                                        } else
                                        {
                                          cubit.addToPicsAddressesList(imageAddress);
                                        }
                                      }
                                    },
                                    onTap: () {
                                      cubit.changeImageIndex(index);
                                      print(index);
                                      String imageAddress = cubit.files[cubit.albumNameIndex].files[index];

                                      if(cubit.multiPhotos==true){
                                        if (cubit.picsAddresses.contains(imageAddress)) {
                                             cubit.removeFromPicsAddressesList(imageAddress);
                                        } else {

                                          cubit.addToPicsAddressesList(imageAddress);
                                        }
                                      }
                                      else{
                                        cubit.picsAddresses.clear();
                                        cubit.addToPicsAddressesList(imageAddress);
                                      }




                                    },
                                    child: Stack(
                                      fit: StackFit.expand,
                                      children: [
                                        Image.file(
                                          File(pic),
                                          fit: BoxFit.cover,
                                        ),
                                        if (cubit.picsAddresses.contains(cubit
                                            .files[cubit.albumNameIndex]
                                            .files[index]))
                                          Icon(
                                            FontAwesomeIcons.check,
                                            size: SizeConfig.screenWidth! / 7,
                                            color: HINT_TEXT_COLOR,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}
