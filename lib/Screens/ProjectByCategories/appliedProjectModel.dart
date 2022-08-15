class AppliedProjectModel {
  final int id;
  final int project_id;
  final int status;
  // final DateTime? createdAt;
  final String name;
  final String due_date;

  AppliedProjectModel({
    required this.id,
    required this.project_id,
    required this.status,
    required this.name,
    required this.due_date,
  });

  factory AppliedProjectModel.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return AppliedProjectModel(
      id: json["id"],
      name: json["project"]["name"],
      due_date: json["project"]["due_date"],
      project_id: json["project_id"],
      status: json["status"],
    );
  }

  static List<AppliedProjectModel> fromJsonList(List list) {
    return list.map((item) => AppliedProjectModel.fromJson(item)).toList();
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
  bool isEqual(AppliedProjectModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
