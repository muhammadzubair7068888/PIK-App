class FreelancerModel {
  final int id;
  final int userId;
  // final DateTime? createdAt;
  final String name;
  final String c;
  final String? avatar;

  FreelancerModel(
      {required this.id,
      required this.name,
      this.avatar,
      required this.c,
      required this.userId});

  factory FreelancerModel.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return FreelancerModel(
      id: json["id"],
      userId: json["user_id"],
      name: json["full_name"],
      avatar: json["image"],
      c: json["categories"][0]["name"],
    );
  }

  static List<FreelancerModel> fromJsonList(List list) {
    return list.map((item) => FreelancerModel.fromJson(item)).toList();
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
  bool isEqual(FreelancerModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
