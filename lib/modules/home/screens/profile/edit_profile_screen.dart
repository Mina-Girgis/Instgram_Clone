import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/add%20post/pick_photo_screen.dart';
import 'package:pro/modules/home/screens/profile/update_profile_data_screen.dart';
import 'package:pro/services/utils/size_config.dart';
import 'package:pro/shared/components/constants.dart';

import '../../../../services/utils/app_navigation.dart';
import '../../components/components.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
            if(state is UpdateUserDataSuccess){
              GlobalCubit.get(context).changeCurrentUser(cubit.userTmp);
            }
        },
        builder: (context, state) {
          return Scaffold(
            // backgroundColor: Colors.white,
            appBar: appBar(
              cubit: cubit,
                title: "Edit profile",
                context: context,
                onSave: () async{
                  await cubit.uploadProfilePic(
                      context: context,
                      username: cubit.userTmp.username,
                      image: cubit.userProfileImageTemp,
                      user:cubit.userTmp,
                  );
                }),
            body: SingleChildScrollView(
              child: Container(
                width: SizeConfig.screenWidth,
                child: Column(
                  children: [
                    circleAvatarDesign(
                        cubit: cubit,
                        radius: 53.0,
                        imageUrl: cubit.userProfileImageTemp,
                    ),
                    TextButton(
                      onPressed: () {
                        cubit.getImagesPath();
                        AppNavigator.customNavigator(context: context, screen: PickImageScreen(postOrProfilePic: 1,title: 'New profile photo',), finish: false);
                      },
                      child: Text(
                        "Change profile photo",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    editProfileInputField(
                      ontab: (){
                        cubit.changeUpdateController(cubit.nameController.text);
                        AppNavigator.customNavigator(context: context, screen: UpdateProfileDataScreen(index: 0), finish: false);
                      },
                      controller: cubit.nameController,
                      onChange: (value){},
                      context: context,
                      label: "Name",
                      // initialValue: "123",
                      index: 0,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    editProfileInputField(
                      ontab: (){
                        // cubit.changeUpdateController(cubit.usernameController.text);
                        // AppNavigator.customNavigator(context: context, screen: UpdateProfileDataScreen(index: 1), finish: false);
                      },
                      controller: cubit.usernameController,
                      onChange: (value){},
                      context: context,
                      label: "Username",
                      // initialValue: "123",
                      index: 0,
                      readOnly: true,
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    editProfileInputField(
                      ontab: (){
                        cubit.changeUpdateController(cubit.bioController.text);
                        AppNavigator.customNavigator(context: context, screen: UpdateProfileDataScreen(index: 2), finish: false);
                      },
                      controller: cubit.bioController,
                      onChange: (value){},
                      context: context,
                      label: "Bio",
                      // initialValue: "123",
                      index: 0,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
