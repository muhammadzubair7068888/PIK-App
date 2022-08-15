class ProjectModel {
  final int id;
  final int seeker_id;
  // final DateTime? createdAt;
  final String name;
  final List? applied;
  final String due_date;

  ProjectModel({
    required this.id,
    required this.seeker_id,
    required this.name,
    required this.due_date,
    required this.applied,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    //  if(json["business_name"] == null){

    //   }
    return ProjectModel(
      id: json["id"],
      name: json["name"],
      due_date: json["due_date"],
      seeker_id: json["user_id"],
      applied: json["applied"],
    );
  }

  static List<ProjectModel> fromJsonList(List list) {
    return list.map((item) => ProjectModel.fromJson(item)).toList();
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
  bool isEqual(ProjectModel model) {
    return this.id == model.id;
  }

  @override
  String toString() => name;
}
