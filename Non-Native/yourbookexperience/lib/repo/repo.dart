import 'package:yourbookexperience/domain/review.dart';

class Repo {
  static List<Review> reviews = getInitReviews();
  static void init() {}

  static List<Review> getReviews() {
    return reviews;
  }

  static void addReview(Review review) {
    if (review.id == -1) {
      review.id = reviews.last.id + 1;
    }
    reviews.add(review);
  }

  static void removeReview(int id) {
    reviews.removeWhere((element) => element.id == id);
  }

  static void updateReview(int oldId, Review newReview) {
    for (int i = 0; i < reviews.length; i++) {
      if (reviews[i].id == oldId) {
        reviews[i] = newReview;
      }
    }
  }

  static List<Review> getInitReviews() {
    return [
      Review(
          id: 0,
          userId: 1,
          bTitle: "Misery",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 1,
          userId: 1,
          bTitle: "Rebirth",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror", "Story"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 2,
          userId: 1,
          bTitle: "It",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Too much blood for my tastes; it quickly becomes old.",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror", "Blood"],
          rating: 5),
      Review(
          id: 3,
          userId: 1,
          bTitle: "Misery",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 4,
          userId: 1,
          bTitle: "Rebirth",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror", "Story"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 5,
          userId: 1,
          bTitle: "It",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Too much blood for my tastes; it quickly becomes old.",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror", "Blood"],
          rating: 5),
      Review(
          id: 6,
          userId: 1,
          bTitle: "Misery",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 7,
          userId: 1,
          bTitle: "Rebirth",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror", "Story"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 8,
          userId: 1,
          bTitle: "It",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Too much blood for my tastes; it quickly becomes old.",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror", "Blood"],
          rating: 5),
      Review(
          id: 9,
          userId: 1,
          bTitle: "Misery",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 10,
          userId: 1,
          bTitle: "Rebirth",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Some stuff here",
          pros: ["Misery", "Pain", "Horror", "Story"],
          cons: ["Misery", "Pain", "Horror"],
          rating: 5),
      Review(
          id: 11,
          userId: 1,
          bTitle: "It",
          bAuthor: "Stephen King",
          description: "Stepheny and Kingy",
          experiences: "Too much blood for my tastes; it quickly becomes old.",
          pros: ["Misery", "Pain", "Horror"],
          cons: ["Misery", "Pain", "Horror", "Blood"],
          rating: 5),
    ];
  }
}
