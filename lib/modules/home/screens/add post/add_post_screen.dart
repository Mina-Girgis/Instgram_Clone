import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../shared/components/constants.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          if(state is AddNewPostSuccess){
            cubit.addPostController.clear();
            Navigator.pop(context);
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(FontAwesomeIcons.x),
              ),
              title: Text("New post"),
              actions: [
                IconButton(
                    onPressed: () {
                      cubit.uploadNewPostImage(
                        username: GlobalCubit.get(context).currentUser.username,
                        image: cubit.files[cubit.albumNameIndex].files[cubit.imageIndex],
                      );

                    },
                    icon: (state is AddNewPostLoading)?CircularProgressIndicator() :Icon(FontAwesomeIcons.check, color: Colors.blue,))
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Container(
                  // width: SizeConfig.screenWidth,
                  // height: SizeConfig.screenHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: SizeConfig.screenWidth! / 5,
                        height: SizeConfig.screenWidth! / 5,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: FileImage(
                                    File(cubit.files[cubit.albumNameIndex].files[cubit.imageIndex]),
                                ),
                                fit: BoxFit.cover
                            ),
                        ),
                      ),
                      SizedBox(width: 10.0,),
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            controller: cubit.addPostController,
                            maxLines: 20,
                            minLines: 1,
                            style: TextStyle(
                              color: WHITE,
                            ),
                            decoration: InputDecoration(
                              hintText: "Write a caption",
                              hintStyle: TextStyle(
                                color: GREY,
                              )
                            ),
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
