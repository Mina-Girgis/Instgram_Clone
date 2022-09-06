import 'package:flutter/material.dart';
import 'package:pro/global_bloc/global_cubit.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text("${GlobalCubit.get(context).currentUser!.username}"),
        centerTitle: true,
      ),
    );
  }
}
