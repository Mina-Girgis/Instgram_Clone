import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pro/modules/home/screens/profile/profile_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';

import '../../../global_bloc/global_cubit.dart';
import '../../../models/user_model.dart';
import '../../../services/utils/size_config.dart';
import '../../../shared/components/constants.dart';
import '../bloc/home_cubit.dart';
import '../components/components.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              cubit.removeBottomNavBarIndexListTop(context: context);
              return true;
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                title: TextFormField(
                  initialValue: cubit.searchController.text,
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      print(value);
                      List<UserModel> list = [];
                      cubit.users.forEach((key, value) {
                        list.add(value);
                      });

                      List<UserModel> searchList = list
                          .where((element) => element.username.contains(value))
                          .toList();
                      cubit.changeSearchList(searchList);
                      cubit.changeSearchController(value);
                    } else {
                      cubit.changeSearchList([]);
                      cubit.changeSearchController("");
                    }
                  },
                  style: TextStyle(
                    color: WHITE,
                  ),
                  cursorColor: WHITE,
                  decoration: InputDecoration(
                    hintText: "Search",
                    hintStyle: TextStyle(
                      color: GREY,
                    ),
                    contentPadding: EdgeInsets.only(left: 10, right: 10),
                    filled: true,
                    fillColor: Colors.white24,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(17),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                ),
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: cubit.searchList.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 10,
                        );
                      },
                      itemBuilder: (context, index) {
                        return InkWell(
                            onTap: () {
                              String usrename =
                              cubit.searchList[index].username.toString();
                              UserModel? user = cubit.users[usrename];
                              cubit.changeUserTmpData(user!);
                              cubit.changeProfileRowIndex(user);
                              AppNavigator.customNavigator(
                                  context: context,
                                  screen: ProfileScreen(
                                    fromSearch: true,
                                  ),
                                  finish: false);
                            },
                            child: searchPersonDesign(
                              context: context,
                                cubit: cubit,
                                user: cubit.searchList[index]));
                      },
                    ),
                    SizedBox(
                      height: 5,
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

Widget searchPersonDesign({required context ,required HomeCubit cubit ,required UserModel user, double radius = 32}) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Row(
      children: [

        storyItem(
          storyList: user.stories,
            context: context,
            username: user.username,
            width: 75,
            height: 75,
            cubit: cubit,
            index: 0,
        ),
        SizedBox(
          width: 15.0,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.username),
            SizedBox(
              height: 3.0,
            ),
            Text(
              user.name,
              style: TextStyle(
                color: GREY,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
