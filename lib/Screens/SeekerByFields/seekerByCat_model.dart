class SeekerByCat {
  final int id;
  // final DateTime? createdAt;
  final String name;
  final String? avatar;

  SeekerByCat({required this.id, required this.name, this.avatar});

  factory SeekerByCat.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return SeekerByCat(
      id: json["id"],
      name: json["full_name"],
      avatar: json["image"],
    );
  }

  static List<SeekerByCat> fromJsonList(List list) {
    return list.map((item) => SeekerByCat.fromJson(item)).toList();
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
  bool isEqual(SeekerByCat model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
