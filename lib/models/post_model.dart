class PostModel{

  late String username;
  late String imageUrl;
  late String time;
  late String description;
  String postId = ""; // comes from database
  PostModel({required this.username,required this.imageUrl,required this.description,required this.time});

  PostModel.fromJson(Map<String,dynamic>json){
    username=json['username'];
    imageUrl=json['imageUrl'];
    time=json['time'];
    description=json['description'];
  }

  Map<String,dynamic> toMap(PostModel model){
    return {
      'username':model.username,
      'imageUrl':model.imageUrl,
      'time':model.time,
      'description':model.description,
    };
  }

  void changePostId(String id){
    postId = id;
  }

}