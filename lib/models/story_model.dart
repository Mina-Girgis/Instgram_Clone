class StoryModel{
  String storyId="";
  late String imageUrl;
  late String time;
  late String username;

  StoryModel({required this.time,required this.imageUrl,required this.username});

  StoryModel.fromJson(Map<String,dynamic>json){
    imageUrl=json['imageUrl'];
    time=json['time'];
    username=json['username'];
  }

  Map<String,dynamic> toMap(StoryModel model){
    return {
      'imageUrl':model.imageUrl,
      'time':model.time,
      'username':model.username,
    };
  }

  void changeStoryId(String id){
    storyId=id;
  }

}