class UserModel{
  late String username;
  late String password;
  late String email;
  late String phoneNumber;
  UserModel({required this.phoneNumber,required this.email,required this.password,required this.username});

  UserModel.empty(){
    username="";
    password="";
    email="";
    phoneNumber="";
  }
  UserModel.fromJson(Map<String,dynamic>json){
    username=json['username']??"";
    password=json['password']??"";
    email=json['email']??"";
    phoneNumber=json['phone']??"";
  }

}