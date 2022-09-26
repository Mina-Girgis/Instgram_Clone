class PostModel{

  late String username;
  late String imageUrl;
  late String time;
  late String description;
  bool isLiked = false;
  String postId = ""; // comes from database
  List<String>likes=[];
  List<CommentModel>comments=[];
  List<dynamic>photos=[];
  PostModel({required this.username,required this.imageUrl,required this.description,required this.time});

  PostModel.empty(){
    username="";
    imageUrl="";
    time="";
    description="";
  }
  PostModel.copy(PostModel model){
    username=model.username;
    imageUrl=model.imageUrl;
    time=model.time;
    description=model.description;
    postId=model.postId;
  }
  PostModel.fromJson(Map<String,dynamic>json){
    username=json['username'];
    imageUrl=json['imageUrl'];
    time=json['time'];
    description=json['description'];
    photos = json['photos'];
  }
  Map<String,dynamic> toMap(PostModel model){
    return {
      'username':model.username,
      'imageUrl':model.imageUrl,
      'time':model.time,
      'description':model.description,
      'photos':model.photos,
    };
  }
  void changePostId(String id){
    postId = id;
  }
  void changeLikesList({required List<String>list}) {
    likes = list;
  }
  void changeCommentList({required List<CommentModel>list}){
    comments=list;
  }
  void changeIsliked(bool b){
    isLiked = b;
  }

  void changePhotosList(List<String>list){
    photos=list;
  }
}


class CommentModel{
  late String username;
  late String time;
  late String text;

  CommentModel({required  this.time,required  this.username,required this.text});

  CommentModel.empty(){
      username="";
      time="";
      text="";
  }

  CommentModel.fromJson(Map<String,dynamic>json){
    username = json['username'];
    time = json['time'];
    text = json['text'];
  }

  Map<String,dynamic> toMap(CommentModel model){
    return {
      'username': model.username,
      'time': model.time,
      'text': model.text,
    };
  }

}



