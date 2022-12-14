import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'dart:io';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_storage_path/flutter_storage_path.dart';
import 'package:meta/meta.dart';
import 'package:pro/global_bloc/global_cubit.dart';
import 'package:pro/models/story_model.dart';
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
  UserModel userTmp = UserModel.empty(); // to switch between different profile screens
  PostModel postTmp = PostModel.empty();
  List<FileModel> files = []; // all pics in your phone
  List<PostModel> allPosts = [];
  List<String> userPostsIds = [];
  List<PostModel> userPosts = [];
  List<UserModel> searchList = [];
  List<List<StoryModel>> activeStories = [];
  List<int> bottomNavBarIndexList = [0]; // to controll navigation (stack)

  Map<String, UserModel> users = {};
  Map<String, bool> storiesSeen = {};
  Map<String,bool>storiesILiked={};

  FileModel? selectedModel;
  int albumNameIndex = -1;
  int imageIndex = -1;
  int profileRowIndex = 0;
  String userProfileImageTemp = "";
  int currentStoryIndex=0;
  bool multiPhotos = false;
  int addStoryIndex = 0;
  List<String> picsAddresses = [];
  List<Widget> screens = [
    HomeScreen(),
    SearchScreen(),
    ReelScreen(),
    ShopScreen(),
    ProfileScreen(
      fromSearch: false,
    ),
    NotificationScreen(),
    FollowRequestScreen(),
  ];

  var nameController = TextEditingController();
  var usernameController = TextEditingController();
  var bioController = TextEditingController();
  var updateController = TextEditingController();
  var addPostController = TextEditingController();
  var commentController = TextEditingController();
  var searchController = TextEditingController();



  void addToPicsAddressesList(String address) {
    if (picsAddresses.length < 10) {
      picsAddresses.add(address);
    } else {
      toastMessage(
          text: "you can't select more than 10 photos",
          backgroundColor: GREY,
          textColor: WHITE);
    }
    emit(AddToPicsAddressesList());
  }

  void addToStoriesILiked(String storyId){
    storiesILiked[storyId]=true;
    emit(AddToStoriesILiked());
  }

  void removeFromPicsAddressesList(String address) {
    picsAddresses.remove(address);
    emit(RemoveFromPicsAddressesList());
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

  void changeAddStoryIndex(value) {
    addStoryIndex = value;
    emit(ChangeAddStoryIndex());
  }

  void changeMultiPhotos() {
    multiPhotos = !multiPhotos;
    if (multiPhotos == false) {
      if (picsAddresses.isNotEmpty) {
        String lastPic = picsAddresses.last;
        picsAddresses.clear();
        picsAddresses.add(lastPic);
      }
    }

    emit(ChangeMultiPhotos());
  }

  void changeSearchList(List<UserModel> list) {
    searchList.clear();
    searchList = list;
    emit(ChangeSearchList());
  }

  void changeCurrentStoryIndex(int index){
    currentStoryIndex=index;
    emit(ChangeCurrentStoryIndex());
  }

  void changeUserProfileImageTemp(String imageurl) {
    userProfileImageTemp = imageurl;
    emit(ChangeUserProfileImageTemp());
  }

  void changeProfileRowIndex(UserModel user) {
    String currentUserName = CacheHelper.getData(key: 'username').toString();
    UserModel? currentUser = users[currentUserName];
    // same profile
    if (user.username == currentUser!.username) {
      profileRowIndex = 0;
    }

    // no follow between two users
    //follow
    else if (user.followers[currentUser.username] == null &&
        user.followRequests[currentUser.username] == null &&
        user.following[currentUser.username] == null) {
      profileRowIndex = 1;
    }

    // current user sent followRequest to another person
    // working well
    // requested
    else if (user.followRequests[currentUser.username] == true) {
      profileRowIndex = 2;
    }

    // two users follow each other
    else if (currentUser.followers[user.username] == true &&
        currentUser.following[user.username] == true) {
      profileRowIndex = 3;
    }

    //currentUser doesn't follow the  user but the user follows currentUser
    // follow back
    else if (currentUser.followers[user.username] == true &&
        currentUser.following[user.username] == null) {
      profileRowIndex = 4;
    }

    // user is one of the currentUser Following
    else if (user.following[currentUser.username] == true) {
      profileRowIndex = 3;
    }
    // current user follows another user but the other user doesn't follow them
    else if (user.followers[currentUser.username] == true) {
      profileRowIndex = 3;
    } else {
      print("Errorrrrrrrrrrrrrrrrr");
      profileRowIndex = 1;
    }
    emit(ChangeProfileRowIndex());
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

  void setUserTmpAsCurrentUserAgain() {
    String? username = CacheHelper.getData(key: 'username').toString();
    UserModel? user = users[username];
    userTmp = user!;
    profileRowIndex = 0;
    emit(SetUserTmpAsCurrentUserAgain());
  }

  Future<void> updateUserData({required String oldUsername, required UserModel user, required context, required imageUrl,}) async {
    try {
      String username = usernameController.text;
      String name = nameController.text;
      String bio = bioController.text;
      if (username == user.username &&
          name == user.name &&
          bio == user.bio &&
          imageUrl == "") {
        toastMessage(
            text: 'No data changed.', backgroundColor: GREY, textColor: WHITE);
      } else {
        emit(UpdateUserDataLoading());
        Map<String, dynamic> mp = {
          'username': username,
          'phone': user.phoneNumber,
          'password': user.password,
          'email': user.email,
          'bio': bio,
          'name': name,
          'imageUrl': imageUrl == "" ? user.imageUrl : imageUrl,
        };
        await FirebaseFirestore.instance
            .collection('users')
            .doc(username)
            .set(mp);
        await getAllUsers();
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

  Future<void> uploadProfilePic(
      {required context,
      required username,
      required String image,
      required UserModel user}) async {
    if (albumNameIndex != -1) {
      emit(UploadProfilePicLoading());
      File file = File(image);
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('profilePic/${Uri.file(file.path).pathSegments.last}')
          .putFile(file)
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          print("******************************");
          await updateUserData(
              oldUsername: username,
              user: user,
              context: context,
              imageUrl: value);
          print("******************************");
          changeUserProfileImageTemp(value);
          emit(UploadProfilePicSuccess());
        }).catchError((error) {
          print(error.toString());
        });
      }).catchError((error) {
        print(error.toString());
        emit(UploadProfilePicFail());
      });
    } else {
      await updateUserData(
          oldUsername: username, user: user, context: context, imageUrl: "");
      emit(UploadProfilePicSuccess());
    }
  }

  Future<List<String>> getAllPostsIdsForSpecicUser(
      {required String username}) async {
    userPostsIds.clear();
    List<String> list = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('myPosts')
        .get()
        .then((value) {
      value.docs.forEach((element) {
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
      print("errrrrrrrrrrrrror");
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
        model.changePostId(element);
        users[username]!.addToPostsList(model);
        emit(GetAllPostsForSpecificUserSuccess());
      });
    });
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
    var videoPath = await StoragePath.videoPath;

    var images = jsonDecode(imagePath!) as List;
    var videos = jsonDecode(videoPath!) as List;

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
    emit(AddNewPostLoading());

    List<String> photosLinks = [];

    picsAddresses.forEach((element) async {
      File file = File(element);
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(file.path).pathSegments.last}')
          .putFile(file)
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          photosLinks.add(value);
          if (photosLinks.length == picsAddresses.length) {
            await addNewPost(
              time: GlobalCubit.get(context).getCurrentTime(),
              description: addPostController.text,
              username: username,
              image: value,
              photosList: photosLinks,
            );
            emit(UploadNewPostImageSuccess());
          }
        }).catchError((error) {
          print(error.toString());
          emit(UploadNewPostImageFail());
        });
      }).catchError((error) {
        print(error.toString());
        emit(UploadNewPostImageFail());
      });
    });
  }



  void uploadNewStory({required context, required username}) async {
    emit(AddNewStoryLoading());
    int count = 0;
    picsAddresses.forEach((element) async {
      File file = File(element);
      await firebase_storage.FirebaseStorage.instance
          .ref()
          .child('posts/${Uri.file(file.path).pathSegments.last}')
          .putFile(file)
          .then((value) {
        value.ref.getDownloadURL().then((value) async {
          await addNewStory(
            time: GlobalCubit.get(context).getCurrentTime(),
            username: username,
            imageUrl: value,
          );
          count++;
          if (picsAddresses.length == count) {
            emit(AddNewStorySuccess());
          }
        }).catchError((error) {
          print(error.toString());
          toastMessage(
              text: 'Upload Fail', backgroundColor: GREY, textColor: WHITE);
          emit(UploadNewStoryImageFail());
        });
      }).catchError((error) {
        print(error.toString());
        toastMessage(
            text: 'Upload Fail', backgroundColor: GREY, textColor: WHITE);
        emit(UploadNewStoryImageFail());
      });
    });
  }

  Future<void> addNewStory({
    required String imageUrl,
    required String username,
    required String time,
  }) async {
    StoryModel story =
        StoryModel(time: time, imageUrl: imageUrl, username: username);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('stories')
        .add(story.toMap(story))
        .then((value) {})
        .catchError((error) {
      print(error.toString());
      emit(AddNewStoryFail());
    });
  }

  Future<void> addNewPost({
    required String image,
    required String description,
    required String username,
    required String time,
    required List<String> photosList,
  }) async {
    PostModel model = PostModel(
      username: username,
      imageUrl: image,
      description: description,
      time: time,
    );
    model.changePhotosList(photosList);
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

  /*******************************/
  // Follow Functions
  Future<void> getAllFollowers({required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('followers')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users[username]?.addToFollowers(username: element.id);
      });
      emit(GetAllFollowersSuccess());
    }).catchError((error) {
      print("getAllFollowersMethod");
      print(error.toString());
      emit(GetAllFollowersFail());
    });
  }

  Future<void> getAllFollowing({required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('following')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users[username]?.addToFollowing(username: element.id);
      });
      emit(GetAllFollowingSuccess());
    }).catchError((error) {
      print("GetAllFollowingMethod");
      print(error.toString());
      emit(GetAllFollowingFail());
    });
  }

  Future<void> getAllFollowRequests({required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('followRequests')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        users[username]?.addToFollowRequest(username: element.id);
      });
      emit(GetAllFollowRequestSuccess());
    }).catchError((error) {
      print("getAllFollowRequestMethod");
      print(error.toString());
      emit(GetAllFollowRequestFail());
    });
  }

  // when you send follow request
  Future<void> addToFollowRequests(
      {required String currentUserName, required String user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('followRequests')
        .doc(currentUserName)
        .set({}).then((value) {
      emit(AddToFollowRequestSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddToFollowRequestFail());
    });
  }

  Future<void> removeFromFollowRequests(
      {required String currentUserName, required String user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('followRequests')
        .doc(currentUserName)
        .delete()
        .then((value) {
      emit(RemoveFromFollowRequestsSuccess());
    }).catchError((error) {
      emit(RemoveFromFollowRequestsFail());
    });
  }

  // when you confirm your follow requests
  Future<void> addToFollowers(
      {required String currentUserName, required String user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserName)
        .collection('followers')
        .doc(user)
        .set({}).then((value) {
      users[currentUserName]!.followers[user] = true;
      emit(AddToFollowersSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddToFollowersFail());
    });
  }

  Future<void> addToFollowing(
      {required String currentUserName, required String user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user)
        .collection('following')
        .doc(currentUserName)
        .set({}).then((value) {
      users[user]!.following[currentUserName] = true;
      emit(AddToFollowingSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddToFollowingFail());
    });
  }

  // when delete requests from your follow request
  Future<void> removeFromMyFollowRequests(
      {required String currentUserName, required String user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUserName)
        .collection('followRequests')
        .doc(user)
        .delete()
        .then((value) {
      users[currentUserName]!.followRequests.remove(user);
      emit(RemoveFromMyFollowRequestsSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(RemoveFromMyFollowRequestsFail());
    });
  }
/*******************************/


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

  Future<void> _addLike(
      {required String postId, required String username}) async {
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

  Future<void> _removeLike(
      {required String postId, required String username}) async {
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

  Future<void> _addToPostsLiked(
      {required String postId, required String username}) async {
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

  Future<void> _removeFromPostsLiked(
      {required String postId, required String username}) async {
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

  Future<List<CommentModel>> getCommentsForSprcificPost(
      {required String postId}) async {
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


  // Stories
  Future<void> getAllViewsForSpecificStory({required String username, required String storyId, required StoryModel model}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection("stories")
        .doc(storyId)
        .collection('views')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        model.addToViews(element.id);
      });

      if (value.docs.length == model.views.length) {
        emit(GetAllViewsForSpecificStorySuccess());
      }
    }).catchError((error) {
      print(error.toString());
      emit(GetAllViewsForSpecificStoryFail());
    });
  }
  Future<void> getAllLikesForSpecificStory({required String username ,required String storyId, required StoryModel model})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('stories')
        .doc(storyId)
        .collection('likes')
        .get()
        .then((value){
          value.docs.forEach((element) {
            model.addToStoryLikes(element.id);
          });
          if(value.docs.length==model.likes.length){
            emit(GetAllLikesForSpecificStorySuccess());
          }
        })
        .catchError((error){
          print(error.toString());
          emit(GetAllLikesForSpecificStoryFail());
    });
  }
  Future<void> getAllStoriesForSpecificUser({required String username}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('stories')
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        StoryModel model = StoryModel.fromJson(element.data());
        await getAllViewsForSpecificStory(username: username,storyId: element.id, model: model);
        await getAllLikesForSpecificStory(username: username,storyId: element.id, model: model);
        model.changeStoryId(element.id);
        users[username]!.stories.add(model);
      });
      emit(GetAllStoriesForSpecificUserSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllStoriesForSpecificUserFail());
    });
  }
  Future<void> getActiveStories({required String username}) async {
    activeStories.clear();
    if (users[username]!.stories.isNotEmpty) {
      activeStories.add(users[username]!.stories);
    }
    users[username]!.following.forEach((key, value) {
      if (users[key]!.stories.isNotEmpty)
        activeStories.add(users[key]!.stories);
    });
    emit(GetActiveStories());
  }

  Future<void>addLikeToSpecificStory({required String username,required String storyOwnerUsername ,required String storyId})async{
    await FirebaseFirestore.instance
        .collection('users')
        .doc(storyOwnerUsername)
        .collection('stories')
        .doc(storyId)
        .collection('likes')
        .doc(username)
        .set({})
        .then((value){
          emit(AddLikeToSpecificStorySuccess());
    })
        .catchError((error){
          print(error.toString());
          emit(AddLikeToSpecificStoryFail());
    });
  }


  // all Stories i have seen
  Future<void> addToStoriesSeen({required String username, required String storyId}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('storiesSeen')
        .doc(storyId)
        .set({}).then((value) {
      emit(AddToStoriesSeenSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(AddToStoriesSeenFail());
    });
  }

  // see one story
  Future<void> seeSpecificStory({required String storyOwner, required String storyId}) async {
    String myUsername = CacheHelper.getData(key: 'username').toString();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(storyOwner)
        .collection('stories')
        .doc(storyId)
        .collection('views')
        .doc(myUsername)
        .set({}).then((value) {
      emit(SeeSpecificStorySuccess());
    }).catchError((error) {
      print(error.toString());
      emit(SeeSpecificStoryFail());
    });
  }

  Future<void> getAllStoriesSeen() async {
    storiesSeen.clear();
    String username = CacheHelper.getData(key: 'username').toString();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(username)
        .collection('storiesSeen')
        .get()
        .then((value) {
      value.docs.forEach((element) {
        storiesSeen[element.id] = true;
        if (storiesSeen.length == value.docs.length) {
          emit(GetAllStoriesSeenSuccess());
        }
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetAllStoriesSeenFail());
    });
  }

  bool allSeen(List<StoryModel> list) {
    bool seen = true;
    list.forEach((element) {
      if (storiesSeen[element.storyId] == null) {
        seen = false;
      }
    });
    // emit(SeenOrNotSucess());
    return seen;
  }
  Color overColor(List<StoryModel> list){
    if(list.isEmpty){
      return Colors.transparent;
    }
    else if(allSeen(list)){
      return Colors.grey;
    }else{
      return Colors.red;
    }

  }


  Future<void> getAllUsers({bool cahngeUserTmp = true}) async {
    users = {};
    await FirebaseFirestore.instance
        .collection('users')
        .get()
        .then((value) async {
      value.docs.forEach((element) async {
        UserModel user = UserModel.fromJson(element.data());
        users[element.id] = user;
        users[element.id]!.posts.clear();
        users[element.id]!.followers.clear();
        users[element.id]!.following.clear();
        users[element.id]!.followRequests.clear();
        users[element.id]!.stories.clear();
        await getAllFollowing(username: element.id);
        await getAllStoriesForSpecificUser(username: element.id);
        await getAllPostsForSpecificUser(username: element.id);
        await getAllFollowers(username: element.id);
        await getAllFollowRequests(username: element.id);
        users[element.id]!.sortStories();
        if (cahngeUserTmp) {
          if (element.id == CacheHelper.getData(key: 'username').toString()) {
            UserModel? user = users[element.id];
            changeUserTmpData(user!);
          }
        }
        if (users.length == value.docs.length) {
          await getActiveStories(username: CacheHelper.getData(key: 'username').toString());
          await getAllStoriesSeen();
        }
      });
      emit(GetAllUsersSuccess());
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUsersFail());
    });
  }

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
    searchController.clear();
    activeStories.clear();
    emit(LogOutSuccess());
  }
}
