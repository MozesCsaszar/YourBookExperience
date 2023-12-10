class Review {
  int id;
  final int userId;
  String bTitle;
  String bAuthor;
  String description;
  String experiences;
  List<String> pros;
  List<String> cons;
  double rating;

  Review({
    required this.id,
    required this.userId,
    required this.bTitle,
    required this.bAuthor,
    required this.description,
    required this.experiences,
    required this.pros,
    required this.cons,
    required this.rating,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'bTitle': bTitle,
      'bAuthor': bAuthor,
      'description': description,
      'experiences': experiences,
      'pros': pros.join("\n"),
      'cons': cons.join("\n"),
      'rating': rating,
    };
  }

  static Review load(Map<String, dynamic> reviewMap) {
    return Review(
        id: reviewMap["id"],
        userId: reviewMap["userId"],
        bTitle: reviewMap["bTitle"],
        bAuthor: reviewMap["bAuthor"],
        description: reviewMap["description"],
        experiences: reviewMap["experiences"],
        pros: reviewMap["pros"].toString().split("\n"),
        cons: reviewMap["cons"].toString().split("\n"),
        rating: reviewMap["rating"].toDouble());
  }
}
