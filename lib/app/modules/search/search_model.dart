class SearchUser {
  final String image;
  final String name;
  final String category;

  final String phone;
  final String email;
  final String city;
  final String businessName;
  final String about;
  final String hobbies;

  static const String imageBase =
      "https://bhartiyacoders.com/WEBSITE/YASH/blf_app_akshay/img/";

  SearchUser({
    required this.image,
    required this.name,
    required this.category,
    required this.phone,
    required this.email,
    required this.city,
    required this.businessName,
    required this.about,
    required this.hobbies,
  });

  factory SearchUser.fromJson(Map<String, dynamic> json) {

    String img = json["profile_image"] ?? "";

    return SearchUser(
      image: img.isEmpty ? "" : imageBase + img,

      name: json["name"] ?? "",
      category: json["business_category"] ?? "",

      phone: json["mobile"] ?? "",
      email: json["email"] ?? "",
      city: json["city"] ?? "",

      businessName: json["business_name"] ?? "",
      about: json["something_aboutme"] ?? "",
      hobbies: json["hobbies"] ?? "",
    );
  }
}