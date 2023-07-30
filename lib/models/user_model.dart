class UserModel {
  late String studentName;
  late String image;
  late String parentPhone;
  late String studentPhone;
  late String uid;
  late String level;
  late String email;
  late bool admin;
  late bool open;

  UserModel({
    required this.uid,
    required this.email,
    required this.studentName,
    required this.image,
    required this.parentPhone,
    required this.studentPhone,
    required this.level,
    required this.admin,
    required this.open,
  });

  UserModel.fromjson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    image = json['image'];
    studentName = json['studentName'];
    parentPhone = json['parentPhone'];
    studentPhone = json['studentPhone'];
    level = json['level'];
    admin = json['admin'];
    open = json['open'];
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'studentName': studentName,
      'image': image,
      'parentPhone': parentPhone,
      'studentPhone': studentPhone,
      'level': level,
      'admin': admin,
      'open': open,
    };
  }
}
