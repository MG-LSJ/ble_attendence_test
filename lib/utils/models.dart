class User {
  String name;
  int id;
  User({required this.name, required this.id});
}

class Student extends User {
  Student({
    required String name,
    required int id,
  }) : super(name: name, id: id);
}

class Teacher extends User {
  Teacher({
    required String name,
    required int id,
  }) : super(
          name: name,
          id: id,
        );
}

User? USER;
