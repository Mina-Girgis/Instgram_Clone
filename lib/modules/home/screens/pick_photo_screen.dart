import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pro/modules/home/bloc/home_cubit.dart';
import 'package:pro/services/utils/size_config.dart';

class PickImageScreen extends StatefulWidget {
  const PickImageScreen({Key? key}) : super(key: key);

  @override
  State<PickImageScreen> createState() => _PickImageScreenState();
}

class _PickImageScreenState extends State<PickImageScreen> {
  @override
  Widget build(BuildContext context) {
    List<String> items = [
      '22222222',
      '12222222sssssssssssssssssssssssssssssssssssssssssssssssssss',
      'Galley',
      '0',
    ];
    var cubit = HomeCubit.get(context);
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            leading: IconButton(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.x),
            ),
            title: Text("New post"),
            actions: [
              IconButton(
                  onPressed: () {}, icon: Icon(FontAwesomeIcons.arrowRight))
            ],
          ),
          body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                snap: true,
                floating: true,
                expandedHeight: SizeConfig.screenHeight! / 2.2,
                toolbarHeight: 40.0,
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.all(0),
                  title: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text("0"),
                        IconButton(
                            onPressed: () {

                              showModalBottomSheet(
                                backgroundColor: Colors.black,
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      width: SizeConfig.screenWidth!/1.5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(height: 5.0,),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                width: SizeConfig.screenWidth!/4,
                                                height: 7.0,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey,
                                                  borderRadius: BorderRadius.circular(10.0),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(height: 5.0,),
                                          ListView.separated(
                                            shrinkWrap: true,
                                              physics: ScrollPhysics(),
                                              itemCount: items.length,
                                              separatorBuilder: (context,index){
                                                return SizedBox(height: 10.0,);
                                              },
                                              itemBuilder: (context,index){
                                                return Container(
                                                  width: SizeConfig.screenWidth!/2,
                                                  child: Text(
                                                    items[index],
                                                    overflow: TextOverflow.ellipsis,

                                                  ),
                                                );
                                              },
                                          ),
                                        ],
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
                  background: FlutterLogo(),
                ),
              ),
              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                  child: Center(
                    child: Text('Scroll to see the SliverAppBar in effect.'),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return Container(
                      color: index.isOdd ? Colors.white : Colors.black12,
                      height: 100.0,
                      child: Center(
                        child: Text('$index', textScaleFactor: 5),
                      ),
                    );
                  },
                  childCount: 20,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
