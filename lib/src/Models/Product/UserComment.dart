class UserComment {
  UserComment({
    this.fullName,
    this.photoUrl,
  });

  String? fullName;
  String? photoUrl;

  factory UserComment.fromJson(Map<String, dynamic> json) => UserComment(
    fullName: json["fullname"],
    photoUrl: json["photoUrl"],
  );

}