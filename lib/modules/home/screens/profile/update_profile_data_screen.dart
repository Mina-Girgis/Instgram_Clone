import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/components/components.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/shared/components/components.dart';

import '../../../../shared/components/constants.dart';
import 'edit_profile_screen.dart';

class UpdateProfileDataScreen extends StatelessWidget {
  late int index;

  UpdateProfileDataScreen({Key? key, required this.index}) : super(key: key);

  // var Controller = TextEditingController(text: "0");
  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: appBar(
            cubit: cubit,
            title: cubit.labels[index],
            context: context,
            onSave: () async {
              if (index == 0) {
                cubit.changeNameController(cubit.updateController.text);
              } else if (index == 1) {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(cubit.updateController.text)
                    .get()
                    .then((value) {
                  print(value.exists);
                  if (!value.exists) {
                    cubit.changeUsernameController(cubit.updateController.text);
                  } else {
                    if (cubit.updateController.text !=
                        cubit.usernameController.text)
                      toastMessage(
                          text: "Username exists",
                          backgroundColor: GREY,
                          textColor: WHITE);
                  }
                }).catchError((error) {
                  print(error.toString());
                });
              } else if (index == 2) {
                cubit.changeBioController(cubit.updateController.text);
              }
              Navigator.of(context, rootNavigator: true).pop();
            },
          ),
          body: Column(
            children: [
              editProfileInputField(
                ontab: () {},
                controller: cubit.updateController,
                onChange: (value) {},
                index: index,
                label: cubit.labels[index],
                context: context,
                readOnly: false,
              )
            ],
          ),
        );
      },
    );
  }
}
