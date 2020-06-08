class Passwords{
  int id;
  String name;
  String password;

  Passwords({
    this.id,
    this.name,
    this.password,
  });

  factory Passwords.fromJson(Map<String, dynamic> data) => new Passwords(
    id: data['id'],
    name: data['name'],
    password: data['password'],
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'password': password,
  };
}