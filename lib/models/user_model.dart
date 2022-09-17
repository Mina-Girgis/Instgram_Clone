class UserModel{
  late String username;
  late String password;
  late String email;
  late String phoneNumber;
  late String name;
  late String bio;
  late String imageUrl;

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



}