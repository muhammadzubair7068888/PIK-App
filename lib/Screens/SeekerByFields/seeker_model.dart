class SeekerModel {
  final int id;
  // final DateTime? createdAt;
  final String name;
  final String c;
  final String? avatar;

  SeekerModel(
      {required this.id, required this.name, this.avatar, required this.c});

  factory SeekerModel.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return SeekerModel(
      id: json["id"],
      name: json["full_name"],
      avatar: json["image"],
      c: json["fields"][0]["name"],
    );
  }

  static List<SeekerModel> fromJsonList(List list) {
    return list.map((item) => SeekerModel.fromJson(item)).toList();
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
  bool isEqual(SeekerModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
