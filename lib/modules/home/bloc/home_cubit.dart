import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:meta/meta.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/models/user_model.dart';
import 'package:pro/modules/home/screens/notifications/notification_screen.dart';
import '../../../models/file_model.dart';
import '../../../models/post_model.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../../../shared/network/local/cache_helper/cache_helper.dart';
import '../screens/home_screen.dart';
import '../screens/notifications/follow_requesrt_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/reel_screen.dart';
import '../screens/search_screen.dart';
import '../screens/shop_screen.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());

  static HomeCubit get(context) => BlocProvider.of(context);
  int bottomNavigationBarIndex = 0;
  List labels = ["Name", "Username", "Bio"];
  List initialValues = [];
  String updatingValueField = "";
  String PostImageUrlFromFireBaseStorage = "";
  UserModel userTmp = UserModel.empty(); // to switch between different profile screens
  PostModel postTmp = PostModel.empty();
  List<FileModel> files = [];
  List<PostModel> allPosts = [];
  List<String> userPostsIds = [];
  List<PostModel> userPosts = [];
  List<UserModel> searchList = [];
  List<int> bottomNavBarIndexList = [0]; // to controll navigation (stack)

  void changeSearchList(List<UserModel> list) {
    searchList.clear();
    searchList = list;
    emit(ChangeSearchList());
  }

  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    ReelScreen(),
    ShopScreen(),
    ProfileScreen(fromSearch: false,),
    NotificationScreen(),
    FollowRequestScreen(),
  ];

  Map<String, UserModel> users = {};
  FileModel? selectedModel;
  int albumNameIndex = -1;
  int imageIndex = -1;
  int profileRowIndex=0;


  void changeProfileRowIndex(UserModel user){
    String currentUserName=CacheHelper.getData(key: 'username').toString();
    UserModel? currentUser = users[currentUserName];
    if(user.username==currentUser!.username){
      profileRowIndex = 0;
    }

    // no follow between two users
    else if(user.followers[currentUser.username]==null&& user.followRequests[currentUser.username]==null&& user.following[currentUser.username]==null) {
      profileRowIndex=1;
    }

    // current user sent followRequest to another person
    // working well
    else if(user.followRequests[currentUser.username]==true)
    {
      profileRowIndex=2;
    }

    else if(currentUser.followers[user.username]==true&&currentUser.following[user.username]==true)
    {
      profileRowIndex=3;
    }
    else if(currentUser.followers[user.username]==true)
    {
      profileRowIndex=3;
    }
    else if(user.following[currentUser.username]==true)
    {
      profileRowIndex=3;
    }

    else{
      profileRowIndex=0;
    }
    emit(ChangeProfileRowIndex());
  }




  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  var updateController = TextEditingController();
  var addPostController = TextEditingController();
  var commentController = TextEditingController();
  var searchController = TextEditingController();

  void whenLogOut() {
    changeBottomNavigationBarIndex(idx: 0);
    userTmp = UserModel.empty();
    postTmp = PostModel.empty();
    files = [];
    allPosts = [];
    userPostsIds = [];
    userPosts = [];
    searchList = [];
    bottomNavBarIndexList = [0];
    users = {};
    albumNameIndex = -1;
    imageIndex = -1;
    emit(LogOutSuccess());
  }

  void changeSearchController(String s) {
    searchController.text = s;
    emit(ChangeSearchController());
  }

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

  void changeDropdownButtonHintText(int idx) {
    albumNameIndex = idx;
    imageIndex = 0;
    emit(ChangeDropdownButtonHintText());
  }

  void changeImageIndex(int idx) {
    imageIndex = idx;
    emit(ChangeImageIndex());
  }

  void changeLikeStateInAllPosts({required String postId}) {
    allPosts.forEach((element) {
      if (element.postId == postId) {
        if (element.isLiked) {
          element.likes.remove(CacheHelper.getData(key: 'username').toString());
        } else {
          element.likes.add(CacheHelper.getData(key: 'username').toString());
        }
        element.changeIsliked(!element.isLiked);
        emit(ChangeLikeStateInAllPosts());
      }
    });
  }

  void removeBottomNavBarIndexListTop({required context}) {
    if (bottomNavBarIndexList.isNotEmpty) {
      bottomNavBarIndexList.removeLast();
      bottomNavBarIndexList.forEach((element) {
        print(element);
      });
      if (bottomNavBarIndexList.isNotEmpty) {
        changeBottomNavigationBarIndex(
            idx: bottomNavBarIndexList.last, add: false);
        // print(bottomNavBarIndexList.last);
      } else {
        SystemNavigator.pop();
      }
    } else {
      SystemNavigator.pop();
    }
    emit(RemoveBottomNavBarIndexListTop());
  }

  void changeBottomNavigationBarIndex({required int idx, bool add = true}) {
    bottomNavigationBarIndex = idx;
    if (add) {
      bottomNavBarIndexList.add(idx);
    }
    if (idx == 4) {
      userPosts.sort((PostModel a, PostModel b) =>
          int.parse(b.time).compareTo(int.parse(a.time)));
    }
    emit(ChangeBottomNavigationBarIndex());
  }

  // Edit profile
  void changePostTempData(PostModel model) {
    postTmp = PostModel.copy(model);
  }

  void changeUserTmpData(UserModel model) {
    userTmp = model;
    emit(ChangeUserTmpData());
  }

  void setUserTmpAsCurrentUserAgain(){
    String?username = CacheHelper.getData(key: 'username').toString();
    UserModel? user = users[username];
    userTmp = user!;
    profileRowIndex=0;
    emit(SetUserTmpAsCurrentUserAgain());
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
      print("---------------");
      print(name);
      print("---------------");
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
        // await deleteUser(oldUsername);
        // await addUser(username, mp, context);
        FirebaseFirestore.instance.collection('users').doc(username).set(mp);
        await getAllUsers();
        // userTmp = UserModel.fromJson(mp);
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
  // check is done .. its working well
  Future<List<String>> getAllPostsIdsForSpecicUser({required String username}) async {
    userPostsIds.clear();
    List<String> list = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        // print(element.id);
        // userPostsIds.add(element.id);
        list.add(element.id);
        emit(GetMyPostsIdsSuccess());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetMyPostsIdsFail());
    });
    return list;
  }

  // check is done .. its working well
  Future<PostModel> getPostById({required String postId}) async {
    PostModel model = PostModel.empty();
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .get()
        .then((value) {
      Map<String, dynamic>? mp = value.data();
      model = PostModel.fromJson(mp!);
      changePostTempData(model);
      emit(GetPostByIdSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetPostByIdFail());
    });
    return model;
  }

  Future<void> getAllPostsForSpecificUser({required String username}) async {
    List<String> ids = [];
    await getAllPostsIdsForSpecicUser(username: username).then((value) {
      ids = value;
    }).catchError((error) {
      print(error.toString());
      emit(GetAllPostsForSpecificUserFail());
    });
    // users[username]!.posts.clear();
    ids.forEach((element) async {
      await getPostById(postId: element).then((value) {
        PostModel model = PostModel.copy(value);
        // print(element);
        model.changePostId(element);
        users[username]!.addToPostsList(model);
        // userPosts.sort((a,b)=>b.time.compareTo(a.time));
        emit(GetAllPostsForSpecificUserSuccess());
      });
    });
    // return userPosts;
  }
  Future<void> getAllPosts() async {
    String? username = CacheHelper.getData(key: 'username');
    await getPostsILiked(username: username.toString()).then((value) async {
      Map<String, bool> isLikedMap = value;

      await FirebaseFirestore.instance.collection('posts').get().then((value) {
        allPosts.clear();
        userPosts.clear();
        value.docs.forEach((element) async {
          PostModel model = PostModel.fromJson(element.data());
          model.changePostId(element.id);

          await getLikesForSpecificPost(postId: element.id).then((value) async {
            model.changeLikesList(list: value);
            await getCommentsForSprcificPost(postId: element.id).then((value) {
              model.changeCommentList(list: value);
              if (isLikedMap[element.id] == true) {
                model.changeIsliked(true);
              }
              allPosts.add(model);
              if (model.username == username) {
                userPosts.add(model);
              }
              allPosts.sort((PostModel a, PostModel b) =>
                  int.parse(b.time).compareTo(int.parse(a.time)));
            });
          }).catchError((error) {
            print(error.toString());
            emit(GetAllPostsFail());
          });
        });

        emit(GetAllPostsSuccess());
      }).catchError((error) {
        print(error.toString());
        emit(GetAllPostsFail());
      });
    }).catchError((error) {
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
    // print(files[0].files[0]);
    emit(GetImagesPathSuccess());
  }

  Future<void> uploadNewPostImage(
      {required context, required username, required String image}) async {
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
          time: GlobalCubit.get(context).getCurrentTime(),
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


  // Follow Functions
  Future<void> getAllFollowers({required String username})async{
      await FirebaseFirestore.instance
          .collection('users')
          .doc(username)
          .collection('followers')
          .get()
          .then((value){
            value.docs.forEach((element) {
              users[username]?.addToFollowers(username: element.id);
            });
           emit(GetAllFollowersSuccess());
      })
          .catchError((error){
            print("getAllFollowersMethod");
            print(error.toString());
            emit(GetAllFollowersFail());
      });
  }
  Future<void> getAllFollowing({required String username})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('following')
        .get()
        .then((value){
      value.docs.forEach((element) {
        users[username]?.addToFollowing(username: element.id);
      });
      emit(GetAllFollowingSuccess());
    })
        .catchError((error){
      print("GetAllFollowingMethod");
      print(error.toString());
      emit(GetAllFollowingFail());
    });
  }
  Future<void> getAllFollowRequests({required String username})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('followRequests')
        .get()
        .then((value){
      value.docs.forEach((element) {
        users[username]?.addToFollowRequest(username: element.id);
      });
      emit(GetAllFollowRequestSuccess());
    })
        .catchError((error){
      print("getAllFollowRequestMethod");
      print(error.toString());
      emit(GetAllFollowRequestFail());
    });
  }

  Future<void>addToFollowRequests({required String currentUserName , required String user})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('followRequests')
        .doc(currentUserName)
        .set({})
        .then((value){
          emit(AddToFollowRequestSuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(AddToFollowRequestFail());
    });

  }
  Future<void>removeFromFollowRequests({required String currentUserName , required String user})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('followRequests')
        .doc(currentUserName)
        .delete()
        .then((value){
          emit(RemoveFromFollowRequestsSuccess());
    })
        .catchError((error){
      emit(RemoveFromFollowRequestsFail());
    });
  }


  // likes
  Future<Map<String, bool>> getPostsILiked({required String username}) async {
    Map<String, bool> mp = {};
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('postsLiked')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        mp[element.id] = true;
      });
      emit(GetPostsILikedSuccess());
    }).catchError((error) {
      emit(GetPostsILikedFail());
    });
    return mp;
  }
  Future<List<String>> getLikesForSpecificPost({required String postId}) async {
    List<String> list = [];
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
    }).catchError((error) {
      print(error.toString());
      emit(GetLikesForSpecificPostFail());
    });
    return list;
  }
  Future<void> _addLike({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(username)
        .set({}).then((value) {
      emit(AddLikeSuccess());
    }).catchError((error) {
      emit(AddLikeFail());
    });
  }
  Future<void> _removeLike({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(username)
        .delete()
        .then((value) {
      emit(RemoveLikeSuccess());
    }).catchError((error) {
      print("removeLikeMethod");
      print(error.toString());
      emit(RemoveLikeFail());
    });
  }
  Future<void> _addToPostsLiked({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('postsLiked')
        .doc(postId)
        .set({}).then((value) {
      emit(AddToPostsLikedSuccess());
    }).catchError((error) {
      print("postsLikedMethod");
      print(error.toString());
      emit(AddToPostsLikedFail());
    });
  }
  Future<void> _removeFromPostsLiked({required String postId, required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('postsLiked')
        .doc(postId)
        .delete()
        .then((value) {
      emit(RemoveFromPostsLikedSuccess());
    }).catchError((error) {
      print("removeFromPostsLikedMethod");
      print(error.toString());
      emit(RemoveFromPostsLikedFail());
    });
  }
  void likePost({required String postId, required String username}) async {
    await _addLike(postId: postId, username: username);
    await _addToPostsLiked(postId: postId, username: username);
    emit(LikePostSuccess());
  }
  void unlikePost({required String postId, required String username}) async {
    await _removeLike(postId: postId, username: username);
    await _removeFromPostsLiked(postId: postId, username: username);
    emit(UnlikePostSuccess());
  }


  // comments
  Future<void> addComment(
      {required String time,
      required String postId,
      required String text,
      required String username}) async {
    CommentModel comment = CommentModel(
      username: username,
      text: text,
      time: time,
    );
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(comment.toMap(comment))
        .then((value) {
      emit(AddCommentSuccess());
    }).catchError((error) {
      print("addCommentMethod");
      print(error.toString());
      emit(AddCommentFail());
    });
  }

  Future<List<CommentModel>> getCommentsForSprcificPost({required String postId}) async {
    List<CommentModel> comments = [];
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        CommentModel comment = CommentModel.fromJson(element.data());
        comments.add(comment);
      });
      emit(GetCommentsForSprcificPostSuccess());
    }).catchError((error) {
      print("emit(GetCommentsForSprcificPostMethod");
      print(error.toString());
      emit(GetCommentsForSprcificPostFail());
    });
    return comments;
  }



  // get all users info and store them in a map
  // each user with their info ,posts
  Future<void> getAllUsers({bool cahngeUserTmp=true}) async {
    users = {};
    await FirebaseFirestore.instance.collection('users').get().then((value) {
      value.docs.forEach((element) async {
        UserModel user = UserModel.fromJson(element.data());
        users[element.id] = user;
        users[element.id]!.posts.clear();
        users[element.id]!.followers.clear();
        users[element.id]!.following.clear();
        users[element.id]!.followRequests.clear();
        await getAllPostsForSpecificUser(username: element.id);
        await getAllFollowers(username: element.id);
        await getAllFollowing(username: element.id);
        await getAllFollowRequests(username: element.id);
        if(cahngeUserTmp){
          if (element.id == CacheHelper.getData(key: 'username').toString()) {
            UserModel? user = users[element.id];
            changeUserTmpData(user!);
          }
        }

      });
      emit(GetAllUsersSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersFail());
    });
  }


}
