class Member {
  final String idMember;
  final String fullName;
  final String nickName;
  final String birthDate;
  final String imageUrl;
  final int tinggiBadan;

  Member({
    required this.idMember,
    required this.fullName,
    required this.nickName,
    required this.birthDate,
    required this.imageUrl,
    required this.tinggiBadan,
  });

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      idMember: json['idMember'],
      fullName: json['fullName'],
      nickName: json['nickName'],
      birthDate: json['birthDate'],
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      tinggiBadan: json['tinggiBadan'] ?? 0,
    );
  }
}
