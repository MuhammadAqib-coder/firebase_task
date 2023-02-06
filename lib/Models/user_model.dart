class UserModel {
  final String name;
  final String designation;
  final String id;
  final String image;

  UserModel(
      {required this.name,
      required this.designation,
      required this.id,
      required this.image});

  factory UserModel.fromJson(json) => UserModel(
      name: json['name'],
      designation: json['designation'],
      id: json['id'],
      image: json['image']);
  Map<String, dynamic> toJson() {
    return {"id": id, "name": name, "designation": designation, "image": image};
  }
}
