import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../shared/components/constants.dart';
import '../components/components.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            children: [
              Image.asset(
                'assets/instaWhite.png',
                width: SizeConfig.defaultSize! * 15,
              ),
              IconButton(
                  onPressed: () {}, icon: Icon(FontAwesomeIcons.arrowDown)),
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.add)),
            IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.heart)),
            IconButton(onPressed: () {}, icon: Icon(FontAwesomeIcons.section)),
          ],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Container(
                  // color: Colors.grey,
                  height: 130.0,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
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
                postDesgin(),
                SizedBox(height: 20.0,),
                postDesgin(),
                SizedBox(height: 20.0,),
                postDesgin(),
                SizedBox(height: 20.0,),
                postDesgin(),
                SizedBox(height: 20.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
