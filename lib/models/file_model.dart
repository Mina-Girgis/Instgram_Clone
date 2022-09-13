class FileModel{
  late List<dynamic>files;
  late String folderName;

  FileModel({required this.files,required this.folderName});

  FileModel.fromJson(Map<String,dynamic>json){
    files = json['files'];
    folderName = json['folderName'];
  }


}