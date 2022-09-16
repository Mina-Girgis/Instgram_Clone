import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:meta/meta.dart';
import 'package:pro/models/user_model.dart';
import '../../../models/file_model.dart';
import '../../../models/post_model.dart';
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
  String PostImageUrlFromFireBaseStorage = "";
  UserModel userTmp = UserModel.empty();
  PostModel postTmp = PostModel.empty();
  List<FileModel> files = [];
  List<PostModel> posts = [];
  List<String> myPostsIds = [];
  FileModel? selectedModel;
  int albumNameIndex = -1;
  int imageIndex = -1;

  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  var updateController = TextEditingController();
  var addPostController = TextEditingController();

  // change controllers
  void changeUpdateController(String s) {
    updateController.text = s;
    emit(ChangeUpdateController());
  }

  void changeNameController(String s) {
    nameController.text = s;
    emit(ChangeNameController());
  }

  void changeUsernameController(String s) {
    usernameController.text = s;
    emit(ChangeUsernameController());
  }

  void changeBioController(String s) {
    bioController.text = s;
    emit(ChangeBioController());
  }

  void changeBottomNavigationBarIndex(int idx) {
    bottomNavigationBarIndex = idx;
    emit(ChangeBottomNavigationBarIndex());
  }

  void changeDropdownButtonHintText(int idx) {
    albumNameIndex = idx;
    emit(ChangeDropdownButtonHintText());
  }

  void changeImageIndex(int idx) {
    imageIndex = idx;
    emit(ChangeImageIndex());
  }


  // Edit profile
  void changePostTempData(PostModel model){
    postTmp = PostModel.copy(model);
  }



  Future<void> updateUserData({
    required String oldUsername,
    required UserModel user,
    required context,
  }) async {
    try {
      String username = usernameController.text;
      String name = nameController.text;
      String bio = bioController.text;
      if (username == user.username && name == user.name && bio == user.bio) {
        toastMessage(
            text: 'No data changed.', backgroundColor: GREY, textColor: WHITE);
      } else {
        Map<String, dynamic> mp = {
          'username': username,
          'phone': user.phoneNumber,
          'password': user.password,
          'email': user.email,
          'bio': bio,
          'name': name,
          'imageUrl': user.imageUrl,
        };
        await deleteUser(oldUsername);
        await addUser(username, mp, context);
        userTmp = UserModel.fromJson(mp);
        toastMessage(
            text: 'Data changed successfully.',
            backgroundColor: GREY,
            textColor: WHITE);
        CacheHelper.putData(key: 'username', value: username);
        print(CacheHelper.getData(key: 'username'));
        emit(UpdateUserDataSuccess());
      }
      Navigator.of(context, rootNavigator: true).pop();
    } catch (error) {
      emit(UpdateUserDataFail());
    }
  }

  Future<void> deleteUser(String username) async {
    // DELETE ALL COLLECTIONS
    List<String> subCollections = ['myPosts'];

    subCollections.forEach((element) async {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .collection(element)
          .get()
          .then((value) {
        value.docs.forEach((element) {
          element.reference.delete();
        });
        // emit(DeleteUserSuccess());
      }).catchError((error) {
        print(error.toString());
        emit(DeleteUserFail());
      });
    });
    // delete data
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

  Future<void> addUser(
      String username, Map<String, dynamic> mp, context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .set(mp)
        .then((value) {
      userTmp = UserModel.fromJson(mp);
      myPostsIds.forEach((element) async {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .collection('myPosts')
            .doc(element)
            .set({})
            .then((value) {})
            .catchError((error) {
              print(error.toString());
            });
      });
      emit(AddUserSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddUserFail());
    });
  }

  // get all posts
  Future<void> getMyPosts({required String username}) async {
    myPostsIds.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.id);
        myPostsIds.add(element.id);
        emit(GetMyPostsSuccess());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetMyPostsFail());
    });
  }

  Future<void> getPostById({required String postId}) async {
    // PostModel model = PostModel.empty();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get().then((value){
         Map<String,dynamic>? mp =  value.data();
         PostModel model = PostModel.fromJson(mp!);
         changePostTempData(model);
         emit(GetPostByIdSuccess());
    }).catchError((error){
        print(error.toString());
        emit(GetPostByIdFail());
    });

  }

  // add post
  Future<void> getImagesPath() async {
    emit(GetImagesPathLoading());
    var imagePath = await StoragePath.imagesPath;
    var images = jsonDecode(imagePath!) as List;
    files = images.map<FileModel>((e) => FileModel.fromJson(e)).toList();
    if (files != null && files.length > 0) {
      selectedModel = files[0];
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

  Future<void> uploadNewPostImage(
      {required username, required String image}) async {
    // String profileImage = files[albumNameIndex].files[imageIndex]; // from imagePicker
    emit(AddNewPostLoading());
    File file = File(image);
    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(file.path).pathSegments.last}')
        .putFile(file)
        .then((value) {
      value.ref.getDownloadURL().then((value) async {
        print(value);
        await addNewPost(
          time: DateTime.now().toString(),
          description: addPostController.text,
          username: username,
          image: value,
        );

        emit(UploadNewPostImageSuccess());
      }).catchError((error) {
        print(error.toString());
      });
    }).catchError((error) {
      print(error.toString());
      emit(UploadNewPostImageFail());
    });
  }

  Future<void> addNewPost({
    required String image,
    required String description,
    required String username,
    required String time,
  }) async {
    PostModel model = PostModel(
      username: username,
      imageUrl: image,
      description: description,
      time: time,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap(model))
        .then((value) async {
      print(value.id);
      await _addToMyPosts(postId: value.id, username: username);
      await getMyPosts(username: username);
      toastMessage(
          text: "Post added successfully.",
          backgroundColor: GREY,
          textColor: WHITE);
      await getAllPosts();
      emit(AddNewPostSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddNewPostFail());
    });
  }

  Future<void> _addToMyPosts(
      {required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .doc(postId)
        .set({});
    // emit(AddToMyPostsSuccess());
  }

  // get from database
  Future<void> getAllPosts() async {
    await FirebaseFirestore.instance.collection('posts').get().then((value) {
      posts.clear();
      value.docs.forEach((element) {
        PostModel model = PostModel.fromJson(element.data());
        model.changePostId(element.id);
        posts.add(model);
        print(model.username);
        print(model.time);
        print(model.postId);
        print(model.description);
        print(model.imageUrl);
      });
      emit(GetAllPostsSuccess());
    }).catchError((error) {
      emit(GetAllPostsFail());
      print(error.toString());
    });
  }
}
