import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/size_config.dart';

import '../../../../models/user_model.dart';
import '../../components/components.dart';

class StoryViewsScreen extends StatelessWidget {
  const StoryViewsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var cubit = HomeCubit.get(context);

    List<Widget> list = [];
    cubit.userTmp.stories.forEach((element) {
      list.add(Container(
        child: Image.network(
          element.imageUrl,
          fit: BoxFit.contain,
        ),
      ));
    });

    return SafeArea(
      child: BlocConsumer<HomeCubit, HomeState>(
        listener: (context, state) {
          // TODO: implement listener
        },
        builder: (context, state) {
          return GestureDetector(
            onHorizontalDragUpdate: (details){

            },
            child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: false,
                  toolbarHeight: 30,
                  actions: [
                    IconButton(
                      onPressed: (){
                        Navigator.pop(context);
                    },
                      icon: Icon(FontAwesomeIcons.x),),
                  ],
                ),
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CarouselSlider(
                  options: CarouselOptions(
                      enableInfiniteScroll: false,
                      autoPlay: false,
                      initialPage: cubit.currentStoryIndex,
                      aspectRatio: 2,
                      viewportFraction: 0.34,
                      // height: SizeConfig.screenHeight!*0.3,
                      enlargeCenterPage: true,
                      onPageChanged: (index, value) {
                        cubit.changeCurrentStoryIndex(index);
                        print(index);
                      }),
                  items: list,
                ),
                Center(
                  child: Icon(
                    Icons.arrow_drop_up_outlined,
                    color: Colors.white,
                    size: 60.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text("${cubit.userTmp.stories[cubit.currentStoryIndex].views.length} Views"),
                ),
                Divider(color: Colors.white24,),
                Expanded(
                  child: Container(
                    // height: 100,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemCount: cubit.userTmp.stories[cubit.currentStoryIndex].views.length,
                      separatorBuilder: (context, index) {
                        return SizedBox(
                          height: 5,
                        );
                      },
                      itemBuilder: (context, index) {
                        String user = cubit.userTmp.stories[cubit.currentStoryIndex].views[index];
                        dynamic model = cubit.users[user];
                        return searchPersonDesign(user: model, radius: 25);
                      },
                    ),
                  ),
                ),
              ],
            )),
          );
        },
      ),
    );
  }
}
