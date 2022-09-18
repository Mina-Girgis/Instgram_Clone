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
  List<FileModel> files   = [];

  List<PostModel> allPosts   = [];
  List<String> userPostsIds = [];
  List<PostModel> userPosts =[];


  Map<String, UserModel> users = {};
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
    if(idx ==4 && userPosts.isEmpty){
      getAllPostsForSpecificUser(username: 'mina_girgis_alfy');
    }
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
  void changePostTempData(PostModel model) {
    postTmp = PostModel.copy(model);
  }
  void changeUserTmpData(UserModel model) {
    userTmp = model;
    emit(ChangeUserTmpData());
  }
  Future<void> updateUserData({required String oldUsername, required UserModel user, required context,}) async {
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
  Future<void> addUser(String username, Map<String, dynamic> mp, context) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .set(mp)
        .then((value) {
      userTmp = UserModel.fromJson(mp);
      userPostsIds.forEach((element) async {
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
  Future<void> getAllPostsIdsForSpecicUser({required String username}) async {
    userPostsIds.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        print(element.id);
        userPostsIds.add(element.id);
        emit(GetMyPostsIdsSuccess());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetMyPostsIdsFail());
    });
  }
  Future<void> getPostById({required String postId}) async {
    // PostModel model = PostModel.empty();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      Map<String, dynamic>? mp = value.data();
      PostModel model = PostModel.fromJson(mp!);
      changePostTempData(model);
      emit(GetPostByIdSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetPostByIdFail());
    });
  }
  Future<void> getAllPostsForSpecificUser({required String username})async {
    userPosts.clear();
    await getAllPostsIdsForSpecicUser(username:username)
        .then((value){
      userPostsIds.forEach((element) async{
        await getPostById(postId: element)
          .then((value){
          PostModel model = PostModel.copy(postTmp);
          model.changePostId(element);
          userPosts.add(model);
          userPosts.sort((a,b)=>b.time.compareTo(a.time));
        }
        );
      });

      emit(GetAllPostsForSpecificUserSuccess());
    }

    );


  }
  Future<void> getAllPosts() async {
    String? username = CacheHelper.getData(key: 'username');
    await getPostsILiked(username:username.toString())
        .then((value)async{

          Map<String,bool>isLikedMap=value;

          await FirebaseFirestore.instance.collection('posts').orderBy('time' ,descending: true).get().then((value) {
            allPosts.clear();
            value.docs.forEach((element) async {
              PostModel model = PostModel.fromJson(element.data());
              model.changePostId(element.id);

              await getLikesForSpecificPost(postId: element.id)
                  .then((value){
                model.changeLikesList(list: value);
                if(isLikedMap[element.id]==true){
                  model.changeIsliked(true);
                }
                allPosts.add(model);
              })
                .catchError((error){
                print(error.toString());
              });
            });
            emit(GetAllPostsSuccess());
          }).catchError((error) {
            print(error.toString());
            emit(GetAllPostsFail());
          });
        })
        .catchError((error){
            emit(GetAllPostsFail());
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
  Future<void> uploadNewPostImage({required username, required String image}) async {
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
  Future<void> addNewPost({required String image, required String description, required String username, required String time,}) async {
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
      await getAllPostsIdsForSpecicUser(username: username);
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
  Future<void> _addToMyPosts({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .doc(postId)
        .set({});
    // emit(AddToMyPostsSuccess());
  }


  // get from database

  Future<void> getAllUsers() async {
    users.clear();
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users[element.id] = UserModel.fromJson(element.data());
      });
      emit(GetAllUsersSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersFail());
    });
  }


  // likes

  Future<Map<String,bool>> getPostsILiked({required String username})async{
      Map<String,bool>mp={};
      await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .collection('postsLiked')
          .get()
          .then((value){
            value.docs.forEach((element) {
              mp[element.id]=true;
            });
          emit(GetPostsILikedSuccess());
      })
          .catchError((error){
          emit(GetPostsILikedFail());
      });
      return mp;
  }

  Future<List<String>>getLikesForSpecificPost({required String postId})async{
    List<String>list=[];
    await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('likes')
          .get()
          .then((value) {
            value.docs.forEach((element) {
              list.add(element.id);
            });
            emit(GetLikesForSpecificPostSuccess());
            // print(list.length);
      })
          .catchError((error){
            print(error.toString());
            emit(GetLikesForSpecificPostFail());
    });
    return list;
  }

  Future<void> addLike({required String postId, required String username})async{
  await FirebaseFirestore.instance
      .collection('posts')
      .doc(postId)
      .collection('likes')
      .doc(username)
      .set({}).then((value) {
        emit(AddLikeSuccess());
  }).catchError((error){
        emit(AddLikeFail());
  });





}
  Future<void> removeLike({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(username)
        .delete()
        .then((value) {
          emit(RemoveLikeSuccess());
    })
        .catchError((error){
          print("removeLikeMethod");
          print(error.toString());
          emit(RemoveLikeFail());
    });
  }

  Future<void> addToPostsLiked({required String postId, required String username})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('postsLiked')
        .doc(postId)
        .set({})
        .then((value){
          emit(AddToPostsLikedSuccess());
    })
        .catchError((error){
          print("postsLikedMethod");
          print(error.toString());
          emit(AddToPostsLikedFail());
    });
  }
  Future<void> removeFromPostsLiked({required String postId, required String username})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('postsLiked')
        .doc(postId)
        .delete()
        .then((value){
          emit(RemoveFromPostsLikedSuccess());
    })
        .catchError((error){
         print("removeFromPostsLikedMethod");
         print(error.toString());
         emit(RemoveFromPostsLikedFail());
    });
  }


}
