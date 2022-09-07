import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:pro/shared/network/local/cache_helper/cache_helper.dart';

import '../models/user_model.dart';

part 'global_state.dart';

class GlobalCubit extends Cubit<GlobalState> {
  GlobalCubit() : super(GlobalInitial());
  static GlobalCubit get(context) => BlocProvider.of(context);
  List<UserModel>globalUsers=[];
  UserModel currentUser =UserModel.empty();

  void changeCurrentUser(UserModel user){
    currentUser=user;
    emit(ChangeCurrentUserSuccess());
  }
  void getAllUsers()async{
    globalUsers.clear();
    await FirebaseFirestore.instance.collection('users').get()
        .then((value){
      value.docs.forEach((element) {
        UserModel user = UserModel.fromJson(element.data());
        globalUsers.add(user);
      });
      print(globalUsers.length);
      getCurrentUser();
      emit(GlobalGetUsersSuccess());
    })
        .catchError((error){
      print(error.toString());
      emit(GlobalGetUsersFail());
    });

  }
  void getCurrentUser(){

    String? username = CacheHelper.getData(key: 'username');
    if(username !='-1')
      {
        globalUsers.forEach((element) {
          if(element.username == username){
            changeCurrentUser(element);
            emit(GetCurrentUserSuccess());
          }
        });

      }
  }


}
