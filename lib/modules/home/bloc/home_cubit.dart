import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:meta/meta.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/models/user_model.dart';

import '../../../models/file_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper/cache_helper.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  int bottomNavigationBarIndex = 0;
  List labels = ["Name", "Username", "Bio"];
  List initialValues = [];
  String updatingValueField = "";
  UserModel userTmp = UserModel.empty();

  List<FileModel> files =[];
  FileModel? selectedModel;
  int albumNameIndex=-1;
  int imageIndex=-1;

  void changeImageIndex(int idx){
    imageIndex=idx;
    emit(ChangeImageIndex());
  }


  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  var updateController = TextEditingController();

  void changeUpdateController(String s){
    updateController.text=s;
    emit(ChangeUpdateController());
  }
  void changeNameController(String s){
    nameController.text=s;
    emit(ChangeNameController());
  }
  void changeUsernameController(String s){
    usernameController.text=s;
    emit(ChangeUsernameController());
  }
  void changeBioController(String s){
    bioController.text=s;
    emit(ChangeBioController());
  }
  void changeBottomNavigationBarIndex(int idx) {
    bottomNavigationBarIndex = idx;
    emit(ChangeBottomNavigationBarIndex());
  }
  void updateUserData({required String oldUsername, required UserModel user, required context,}){
    try{
      String username = usernameController.text;
      String name  = nameController.text;
      String bio  = bioController.text;
      if(username==user.username && name==user.name && bio == user.bio){
          toastMessage(text: 'No data changed.', backgroundColor: GREY, textColor: WHITE);
      }
      else{
        Map<String,dynamic>mp={
          'username':username,
          'phone':user.phoneNumber,
          'password':user.password,
          'email':user.email,
          'bio':bio,
          'name':name,
          'imageUrl':user.imageUrl,
        };
        deleteUser(oldUsername);
        addUser(username, mp, context);
        userTmp = UserModel.fromJson(mp);
        toastMessage(text: 'Data changed successfully.', backgroundColor: GREY, textColor: WHITE);
        CacheHelper.putData(key: 'username', value: username);
        print(CacheHelper.getData(key: 'username'));
        emit(UpdateUserDataSuccess());
      }
      Navigator.of(context,rootNavigator: true).pop();

    }catch(error){
      emit(UpdateUserDataFail());
    }
  }
  void deleteUser(String username) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .delete()
        .then((value) {
      emit(DeleteUserSuccess());
    }).catchError((error) {
      emit(DeleteUserFail());
    });
  }
  void addUser(String username, Map<String, dynamic> mp,context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .set(mp)
        .then((value) {
       userTmp = UserModel.fromJson(mp);
       emit(AddUserSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddUserFail());
    });
  }




  void changeDropdownButtonHintText(int idx){
    albumNameIndex=idx;
    emit(ChangeDropdownButtonHintText());
  }
  void getImagesPath() async {
    emit(GetImagesPathLoading());
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0)
      {
        selectedModel=files[0];
        albumNameIndex = 0;
        imageIndex = 0;
      }
    files.forEach((element) {
      print(element.folderName);
      print(element.files.length);
      print(element.files[0].toString());
      print("----------------------");
    });
    print("------------------------");
    print(files[0].files[0]);

    emit(GetImagesPathSuccess());
  }



}

















