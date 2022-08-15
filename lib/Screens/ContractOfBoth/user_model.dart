class UserModel {
  final int id;
  // final DateTime? createdAt;
  final String name;
  final String? avatar;

  UserModel({required this.id, required this.name, this.avatar});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return json["business_name"] == null
        ? UserModel(
            id: json["id"],
            name: json["first_name"] + " " + json["last_name"],
            avatar: json["image"],
          )
        : UserModel(
            id: json["id"],
            name: json["business_name"],
            avatar: json["image"],
          );
  }

  static List<UserModel> fromJsonList(List list) {
    return list.map((item) => UserModel.fromJson(item)).toList();
  }

  ///this method will prevent the override of toString
  String userAsString() {
    return '#${this.id} ${this.name}';
  }

  ///this method will prevent the override of toString
  // bool userFilterByCreationDate(String filter) {
  //   return this.createdAt?.toString().contains(filter) ?? false;
  // }

  ///custom comparing function to check if two users are equal
  bool isEqual(UserModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
