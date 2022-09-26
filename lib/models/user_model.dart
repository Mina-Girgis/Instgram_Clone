import 'package:pro/models/post_model.dart';
import 'package:pro/models/story_model.dart';

class UserModel{
  late String username;
  late String password;
  late String email;
  late String phoneNumber;
  late String name;
  late String bio;
  late String imageUrl;
  List<PostModel>posts=[];
  List<StoryModel>stories=[];
  Map<String,bool>followers ={};
  Map<String,bool>following ={};
  Map<String,bool>followRequests ={};

  UserModel({
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.username,
    required this.imageUrl,
    required this.name,
    required this.bio
  });

  UserModel.empty(){
    username="";
    password="";
    email="";
    phoneNumber="";
    name="";
    bio="";
    imageUrl="";
  }

  UserModel.copy(UserModel model){
    username = model.username;
    password = model.password;
    email = model.email;
    phoneNumber = model.phoneNumber;
    name = model.name;
    bio = model.bio;
    imageUrl = model.imageUrl;
  }


  UserModel.fromJson(Map<String,dynamic>json){
    username=json['username']??"";
    password=json['password']??"";
    email=json['email']??"";
    phoneNumber=json['phone']??"";
    name=json['name']??json['username'];
    bio=json['bio']??"";
    imageUrl=json['imageUrl']??"https://i.pinimg.com/564x/66/ff/cb/66ffcb56482c64bdf6b6010687938835.jpg";
  }

  void addToPostsList(PostModel model){
    posts.add(model);
    posts.sort((a,b)=>int.parse(b.time).compareTo(int.parse(a.time)));
  }

  void addToFollowers({required String username}){
    followers[username]=true;
  }
  void addToFollowing({required String username}){
    following[username]=true;
  }
  void addToFollowRequest({required String username}){
    followRequests[username]=true;
  }

  void addToStories(StoryModel story){
    stories.add(story);
    stories.sort((a,b)=>int.parse(a.time).compareTo(int.parse(b.time)));
  }


}