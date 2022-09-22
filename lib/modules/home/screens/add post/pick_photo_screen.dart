import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../shared/components/constants.dart';
import 'add_post_screen.dart';

class PickImageScreen extends StatefulWidget {
  int postOrProfilePic;
  PickImageScreen({Key? key,required this.postOrProfilePic}) : super(key: key);

  @override
  State<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends State<PickImageScreen> {
  late ScrollController _scrollController;

  @override
  Widget build(BuildContext context) {
    _scrollController = ScrollController();
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {
                cubit.imageIndex=-1;
                cubit.albumNameIndex=-1;
                Navigator.pop(context);
              },
              icon: Icon(FontAwesomeIcons.x),
            ),
            title: Text("New post"),
            actions: [
              if(cubit.files.isNotEmpty)
                  IconButton(
                onPressed: () {
                  if(widget.postOrProfilePic==0){
                    AppNavigator.customNavigator(context: context, screen: AddPostScreen(), finish: false);
                  }else{
                    cubit.changeUserProfileImageTemp(cubit.files[cubit.albumNameIndex].files[cubit.imageIndex]);
                    Navigator.pop(context);
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
                                  onTap: () {
                                    cubit.changeImageIndex(index);
                                    print(index);
                                    print(cubit.files[cubit.albumNameIndex]
                                        .files[index]);
                                    // _scrollController.animateTo(
                                    //   _scrollController.position.,
                                    //   duration: Duration(milliseconds: 500),
                                    //   curve: Curves.decelerate,
                                    // );
                                  },
                                  child: Image.file(
                                    File(pic),
                                    fit: BoxFit.cover,
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
        );
      },
    );
  }
}
