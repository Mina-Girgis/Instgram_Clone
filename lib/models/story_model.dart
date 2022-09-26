class StoryModel{
  late String storyId;
  late String imageUrl;
  late String time;
  late String username;

  StoryModel({required this.storyId,required this.time,required this.imageUrl,required this.username});

  StoryModel.fromJson(Map<String,dynamic>json){
    imageUrl=json['imageUrl'];
    time=json['time'];
    username=json['username'];
  }


}