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
}
