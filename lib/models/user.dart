class User {
  String? idUser;
  String nama;
  String email;
  String password;
  String? favMember; 

  User({
    this.idUser,
    required this.nama,
    required this.email,
    required this.password,
    this.favMember,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      idUser: json['idUser']?.toString(),
      nama: json['nama'],
      email: json['email'],
      password: json['password'],
      favMember: json['favMember']?.toString(), 
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'email': email,
      'password': password,
      'favMember': favMember, 
    };
  }
}
