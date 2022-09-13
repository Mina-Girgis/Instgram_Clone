import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/modules/home/screens/pick_photo_screen.dart';
import 'package:pro/services/utils/app_navigation.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../shared/components/constants.dart';
import '../components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    var cubit = HomeCubit.get(context);
    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: 60,
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              title: Row(
                children: [
                  Image.asset(
                    'assets/instaWhite.png',
                    width: SizeConfig.defaultSize! * 15,
                  ),
                  ButtonTheme(
                    child: IconButton(
                      splashRadius: 15,
                      iconSize: 30.0,
                      alignment: Alignment.centerLeft,
                      onPressed: () {},
                      icon: Icon(
                        IconData(
                          0xf13d,
                          fontFamily: 'MaterialIcons',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                IconButton(
                  iconSize: 30.0,
                  splashRadius: 15,
                  onPressed: () {
                    cubit.getImagesPath();
                    AppNavigator.customNavigator(context: context, screen: PickImageScreen(), finish: false);
                  },
                  icon: Icon(
                    Icons.add_box_outlined,
                  ),
                ),
                IconButton(
                  iconSize: 30.0,
                  splashRadius: 15,
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite_border,
                  ),
                ),
                Transform.rotate(
                    angle: 50,
                    child: IconButton(
                        iconSize: 30.0,
                        splashRadius: 15,
                        onPressed: () {},
                        icon: Icon(
                          Icons.send_outlined,
                        ))),
              ],
            ),

            body: RefreshIndicator(
              onRefresh: () async {},
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Container(
                      width: SizeConfig.screenWidth,
                      child: Column(
                        children: [
                          Container(
                            // color: Colors.grey,
                            height: 130.0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8.0),
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: 10,
                                separatorBuilder: (context, index) {
                                  return SizedBox(
                                    width: 15.0,
                                  );
                                },
                                itemBuilder: (context, index) {
                                  return storyDesignItem();
                                },
                              ),
                            ),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemCount: 5,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10.0,
                              );
                            },
                            itemBuilder: (context, index) {
                              return postDesgin();
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }


}
